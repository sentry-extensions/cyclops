#!/usr/bin/env python
# -*- coding: utf-8 -*-

from preggy import expect
from tornado.testing import AsyncHTTPTestCase
import msgpack

from cyclops.app import CyclopsApp
from cyclops.config import Config


class TestRouterHandler(AsyncHTTPTestCase):
    def get_app(self):
        cfg = Config(
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

        expect(self.app.items_to_process[item]).to_length(1)

        project_id, method, headers, url, body = msgpack.unpackb(self.app.items_to_process[item].get())
        expect(project_id).to_equal(item)
        expect(method).to_equal("GET")

        expect(headers).to_include("Host")
        expect(headers).to_include("Accept-Encoding")
        expect(headers).to_include("Accept")
        expect(headers).to_include("User-Agent")

        expect(url).to_equal("localhost:9000/api/1/store/?sentry_key=ee0c9d854b294d20a2d6d92d0191cac8")
        expect(body).to_be_empty()
