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
    message = { 'time_spent': None,
                'sentry.interfaces.Message':
                    {'message': 'teste',
                     'params': []
                    },
                'server_name': 'Guilherme-Souza.local',
                'tags': {},
                'event_id': 'd152d02f392945389dee3e3c072e1f5a',
                "timestamp": time.time(),
                'extra':
                    {'sys.argv': ["'globoapi/server.py'",
                                   "'-p'",
                                   "'8989'",
                                   "'-c'",
                                   "'/Users/guilhermef/projetos/home/api/globoapi/globoapi.conf'",
                                   "'-l'", "'info'"]
                    },
                'modules': {},
                'project': '2',
                'platform': 'python',
                'message': 'teste',
                'level': 40}
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


class TestGetRouterHandler(AsyncHTTPTestCase):
    def get_app(self):
        cfg = get_config(
            CACHE_IMPLEMENTATION_CLASS='cyclops.cache.RedisCache',
            REDIS_HOST='localhost',
            REDIS_PORT=7780,
            REDIS_DB_COUNT=0,
            REDIS_PASSWORD=None
        )

        self.app = CyclopsApp(config=cfg)
        return self.app

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

        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("1")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("PROCESSED")

        expect(self.app.processed_items).to_equal(1)

        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("GET")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expect(url).to_equal("localhost:9000/api/1/store/?sentry_key=ee0c9d854b294d20a2d6d92d0191cac8")
        expect(body).to_be_empty()

    def test_get_valid_project_with_valid_key_ignores(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]

        for i in range(self.app.config.MAX_CACHE_USES + 1):
            response = self.fetch('/api/%s/store/?sentry_key=%s' % (item, key))

        expect(response.code).to_equal(304)
        expect(response.body).to_be_empty()

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("12")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("IGNORED")


class TestPostRouterHandler(AsyncHTTPTestCase):
    def get_app(self):
        cfg = get_config(
            CACHE_IMPLEMENTATION_CLASS='cyclops.cache.RedisCache',
            REDIS_HOST='localhost',
            REDIS_PORT=7780,
            REDIS_DB_COUNT=0,
            REDIS_PASSWORD=None
        )

        self.app = CyclopsApp(config=cfg)
        return self.app

    def test_post_fails_if_no_auth_header_supplied(self):
        response = self.fetch('/api/store/', method="POST", body="x=1")

        expect(response.code).to_equal(404)
        expect(response.body).to_be_empty()

    def test_post_fails_if_auth_header_does_not_include_public_key(self):
        headers = {
            'X-Sentry-Auth': "invalid header"
        }

        response = self.fetch('/api/store/', method="POST", headers=headers, body="x=1")

        expect(response.code).to_equal(404)
        expect(response.body).to_be_empty()

    def test_post_fails_if_auth_header_does_not_include_secret(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]

        headers = {
            'X-Sentry-Auth': """X-Sentry-Auth: Sentry sentry_version=4,
                                sentry_client=1.0.0,
                                sentry_timestamp=%s,
                                sentry_key=%s,""" % (time.time(), key)
        }

        response = self.fetch('/api/store/', method="POST", headers=headers, body="x=1")

        expect(response.code).to_equal(404)
        expect(response.body).to_be_empty()

    def test_post_fails_if_auth_header_is_invalid_project(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = "invalid-secret"

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        response = self.fetch('/api/store/', method="POST", headers=headers, body="x=1")

        expect(response.code).to_equal(404)
        expect(response.body).to_be_empty()

    def test_post_works_if_proper(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = self.app.project_keys[item]['secret_key'][0]

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload()
        response = self.fetch('/api/store/', method="POST", headers=headers, body=payload)

        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("3")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("PROCESSED")

        expect(self.app.processed_items).to_equal(1)

        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("POST")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expected_url = "http://ee0c9d854b294d20a2d6d92d0191cac8:0baca85229c74e0f95d52bea5418ddfd@localhost:9000/api/store/?"
        expect(url).to_equal(expected_url)
        expect(body).to_equal(payload)

    def test_post_new_url_works_if_proper(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = self.app.project_keys[item]['secret_key'][0]

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload()
        response = self.fetch('/api/%s/store/' % item, method="POST", headers=headers, body=payload)

        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("1")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("PROCESSED")

        expect(self.app.processed_items).to_equal(1)

        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("POST")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expected_url = "http://ee0c9d854b294d20a2d6d92d0191cac8:0baca85229c74e0f95d52bea5418ddfd@localhost:9000/api/%s/store/?" % item
        expect(url).to_equal(expected_url)
        expect(body).to_equal(payload)

    def test_post_message_works_if_proper(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = self.app.project_keys[item]['secret_key'][0]

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_message_payload()
        response = self.fetch('/api/%s/store/' % item, method="POST", headers=headers, body=payload)

        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("1")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("PROCESSED")

        expect(self.app.processed_items).to_equal(1)

        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("POST")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expected_url = "http://ee0c9d854b294d20a2d6d92d0191cac8:0baca85229c74e0f95d52bea5418ddfd@localhost:9000/api/%s/store/?" % item
        expect(url).to_equal(expected_url)
        expect(body).to_equal(payload)

    def test_post_works_if_gzipped(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = self.app.project_keys[item]['secret_key'][0]

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload(gzipped=True)
        response = self.fetch('/api/store/', method="POST", headers=headers, body=payload)

        expect(response.code).to_equal(200)
        expect(response.body).to_equal("OK")

        expect(self.app.processed_items).to_equal(1)

        expect(self.app.storage.get_size(item)).to_equal(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.storage.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("POST")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expected_url = "http://ee0c9d854b294d20a2d6d92d0191cac8:0baca85229c74e0f95d52bea5418ddfd@localhost:9000/api/store/?"
        expect(url).to_equal(expected_url)
        expect(body).to_equal(payload)

    def test_post_valid_project_with_valid_key_ignores(self):
        item = self.app.project_keys.keys()[0]
        key = self.app.project_keys[item]['public_key'][0]
        secret = self.app.project_keys[item]['secret_key'][0]

        headers = {
            'X-Sentry-Auth': get_sentry_auth(key, secret)
        }

        payload = get_post_payload(culprit="some.other.culprit")

        for i in range(self.app.config.MAX_CACHE_USES + 1):
            response = self.fetch('/api/store/', method="POST", headers=headers, body=payload)

        expect(response.code).to_equal(304)
        expect(response.body).to_be_empty()

        expect(response.headers).to_include("X-CYCLOPS-CACHE-COUNT")
        expect(response.headers['X-CYCLOPS-CACHE-COUNT']).to_equal("11")
        expect(response.headers).to_include("X-CYCLOPS-STATUS")
        expect(response.headers['X-CYCLOPS-STATUS']).to_equal("IGNORED")


class TestCountHandler(AsyncHTTPTestCase):
    def get_app(self):
        cfg = get_config(
            CACHE_IMPLEMENTATION_CLASS='cyclops.cache.RedisCache',
            REDIS_HOST='localhost',
            REDIS_PORT=7780,
            REDIS_DB_COUNT=0,
            REDIS_PASSWORD=None
        )

        self.app = CyclopsApp(config=cfg)
        return self.app

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
