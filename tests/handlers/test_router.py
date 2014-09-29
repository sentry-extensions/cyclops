#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import base64
from zlib import compress

from ujson import dumps, loads
from preggy import expect
from tornado.testing import AsyncHTTPTestCase
import msgpack

from cyclops.app import CyclopsApp
from tests.helpers import get_config


def get_sentry_auth(key, secret):
    return """
        X-Sentry-Auth: Sentry sentry_version=4,
        sentry_client=1.0.0,
        sentry_timestamp=%s,
        sentry_key=%s,
        sentry_secret=%s
    """.strip() % (
        time.time(),
        key,
        secret
    )


def get_message_payload():
    message = {
            'time_spent': None,
            'sentry.interfaces.Message': {
                'message': 'teste',
                'params': []
                },
            'server_name': 'Guilherme-Souza.local',
            'tags': {},
            'event_id': 'd152d02f392945389dee3e3c072e1f5a',
            "timestamp": time.time(),
            'extra': {
                'sys.argv': [
                    "'globoapi/server.py'",
                    "'-p'",
                    "'8989'",
                    "'-c'",
                    "'/Users/guilhermef/projetos/home/api/globoapi/globoapi.conf'",
                    "'-l'",
                    "'info'"
                    ]
                },
            'modules': {},
            'project': '2',
            'platform': 'python',
            'message': 'teste',
            'level': 40
            }
    return dumps(message)

def get_post_payload(
        event_id="fc6d8c0c43fc4630ad850ee518f1b9d0",
        culprit="my.module.function_name",
        message="SyntaxError: Wattttt!",
        gzipped=False):

    result = dumps({
        "event_id": event_id,
        "culprit": culprit,
        "timestamp": time.time(),
        "message": message,
        "tags": {
            "ios_version": "4.0"
        },
        "exception": [{
            "type": "SyntaxError",
            "value": "Wattttt!",
            "module": "__builtins__"
        }]
    })

    if gzipped:
        result = base64.b64encode(compress(result))

    return result


class BaseRouterTest(AsyncHTTPTestCase):
    def setUp(self):
        super(BaseRouterTest, self).setUp()
        # self._app is set to self.get_app() in mother setUp() call
        self.app = self._app
        self.app.cache.flushdb()
        self.valid_project_id = self.app.project_keys.keys()[0]

    def get_app(self):
        cfg = get_config(
            CACHE_IMPLEMENTATION_CLASS='cyclops.cache.RedisCache',
            REDIS_HOST='localhost',
            REDIS_PORT=7780,
            REDIS_DB_COUNT=0,
            REDIS_PASSWORD=None
        )
        return CyclopsApp(config=cfg)

    def expect_404(self, response):
        expect(response.code).to_equal(404)
        expect(response.body).to_be_empty()

    def expect_200(self, response):
        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

    def expect_200_ignored(self, response):
        expect(response.code).to_equal(200)
        expect(response.body).to_equal("IGNORED")

    def api_store_url(self, item=None):
        url = "http://ee0c9d854b294d20a2d6d92d0191cac8:0baca85229c74e0f95d52bea5418ddfd@localhost:9000/api/"
        if item is not None:
            url += "%s/store/?" % item
        else:
            url += "store/?"
        return url

    def get_project_keys(self):
        project_id = self.valid_project_id
        public_key = self.app.project_keys[project_id]['public_key'][0]
        secret_key = self.app.project_keys[project_id]['secret_key'][0]
        return project_id, public_key, secret_key

    def expect_correct_response_headers(self,
            response,
            expected_status,
            expected_cache_count=1):
        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal(str(expected_cache_count))
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal(expected_status)

    def expect_one_processed_item(self, item,
            expected_method,
            expected_url,
            expected_body=None):
        expect(self.app.processed_items).to_equal(1)
        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)

        expect(method).to_equal(expected_method)
        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expect(url).to_equal(url)
        if expected_body is None:
            expect(body).to_be_empty()
        else:
            expect(body).to_equal(expected_body)


class TestGetRouterHandler(BaseRouterTest):

    def test_get_invalid_project_returns_404(self):
        response = self.fetch('/api/999999/store/')
        expect(response.code).to_equal(404)

    def test_get_valid_project_with_invalid_key(self):
        response = self.fetch('/api/%s/store/?sentry_key=%s' % (self.app.project_keys.keys()[0], "invalid_key"))
        expect(response.code).to_equal(403)
        expect(response.body).to_equal("INVALID KEY")

    def test_get_valid_project_with_valid_key(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        response = self.fetch('/api/%s/store/?sentry_key=%s' % (item, key))

        self.expect_200(response)

        self.expect_correct_response_headers(response, "PROCESSED")

        self.expect_one_processed_item(item, "GET",
                "localhost:9000/api/1/store/?sentry_key=ee0c9d854b294d20a2d6d92d0191cac8")

    def test_get_valid_project_with_valid_key_ignores(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]

        for _i in range(self.app.config.MAX_CACHE_USES + 1):
            response = self.fetch('/api/%s/store/?sentry_key=%s' % (item, key))

        self.expect_200_ignored(response)

        self.expect_correct_response_headers(response, "IGNORED",
                expected_cache_count=self.app.config.MAX_CACHE_USES + 1)


class TestPostRouterHandler(BaseRouterTest):

    def post_expect_404(self, item=None, headers=None, body=None):
        url = '/api/store/' if item is None else '/api/%s/store/' % item
        response = self.fetch(url, method="POST", headers=headers, body=body)
        self.expect_404(response)

    def expect_post_works(self, url, gzipped=False):
        item, key, secret = self.get_project_keys()

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload()
        response = self.fetch(url, method="POST", headers=headers, body=payload)

        self.expect_200(response)
        self.expect_correct_response_headers(response, "PROCESSED")
        self.expect_one_processed_item(item, "POST", self.api_store_url(), payload)

    def test_post_fails_if_no_auth_header_supplied(self):
        response = self.fetch('/api/store/', method="POST", body="x=1")
        self.expect_404(response)

    def test_post_fails_if_auth_header_does_not_include_public_key(self):
        headers = {
            'X-Sentry-Auth': "invalid header"
        }
        self.post_expect_404(headers=headers, body="x=1")

    def test_post_fails_if_auth_header_does_not_include_secret(self):
        _item, key, _secret = self.get_project_keys()

        headers = {
            'X-Sentry-Auth': """X-Sentry-Auth: Sentry sentry_version=4,
                                sentry_client=1.0.0,
                                sentry_timestamp=%s,
                                sentry_key=%s,""" % (time.time(), key)
        }
        self.post_expect_404(headers=headers, body="x=1")

    def test_post_fails_if_auth_header_is_invalid_project(self):
        _item, key, secret = self.get_project_keys()
        secret = "invalid-secret"

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }
        self.post_expect_404(headers=headers, body="x=1")

    def test_post_fails_with_valid_project_and_invalid_key(self):
        item, _key, _secret = self.get_project_keys()
        key = "allyourbase"
        secret = "arebelongtous"
        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }
        self.post_expect_404(item=item, headers=headers, body=get_post_payload())

    def test_post_works_if_proper(self):
        self.expect_post_works('/api/store/')

    def test_post_new_url_works_if_proper(self):
        item, _key, _secret = self.get_project_keys()
        self.expect_post_works('/api/%s/store/' % item)

    def test_post_works_if_gzipped(self):
        self.expect_post_works('/api/store/', gzipped=True)

    def test_post_valid_project_with_valid_key_ignores(self):
        _item, key, secret = self.get_project_keys()

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload(culprit="some.other.culprit")

        for _i in range(self.app.config.MAX_CACHE_USES + 1):
            response = self.fetch('/api/store/', method="POST", headers=headers, body=payload)

        self.expect_200_ignored(response)
        self.expect_correct_response_headers(response, "IGNORED",
                expected_cache_count=self.app.config.MAX_CACHE_USES + 1)


class TestCountHandler(BaseRouterTest):

    def test_get_count(self):
        self.app.average_request_time = 10
        self.app.percentile_request_time = 20
        self.app.processed_items = 30
        self.app.ignored_items = 40

        response = self.fetch('/count')

        expect(response.code).to_equal(200)
        expect(response.body).not_to_be_empty()

        result = loads(response.body)
        expect(result['count']).to_equal(0)
        expect(result['average']).to_equal(10)
        expect(result['percentile']).to_equal(20)
        expect(result['processed']).to_equal(30)
        expect(result['ignored']).to_equal(40)
