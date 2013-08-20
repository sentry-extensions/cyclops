#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
from zlib import decompress
from base64 import b64decode
from random import randint

import tornado.web
from ujson import dumps, loads
#import msgpack

from cyclops.handlers.base import BaseHandler

SENTRY_KEY = re.compile(r'sentry_key\=(.+),')
SENTRY_SECRET = re.compile(r'sentry_secret\=(.+),?')


class BaseRouterHandler(BaseHandler):

    def _404(self):
        self.set_status(404)
        self.finish()

    def validate_cache(self, url):
        count = 0

        if self.application.config.URL_CACHE_EXPIRATION > 0:
            if self.application.cache.get(url) is None:
                self.application.cache.set(url, self.application.config.URL_CACHE_EXPIRATION)

            count = self.application.cache.incr(url)
            if count > self.application.config.MAX_CACHE_USES:
                self.set_status(304)
                self.set_header("X-CYCLOPS-CACHE-COUNT", str(count))
                self.set_header("X-CYCLOPS-STATUS", "IGNORED")
                self.application.ignored_items += 1
                self.finish()
                return count

        return count

    def process_request(self, project_id, url):
        headers = self.request.headers
        body = self.request.body

        message = (
            project_id,
            self.request.method,
            headers,
            url,
            body
        )

        self.application.storage.put(project_id, message)
        #self.application.items_to_process[project_id].put(msgpack.packb(message))

        self.set_status(200)
        self.write("OK")
        self.finish()

    def backend_request(self, project_id=None):
        auth = self.request.headers.get('X-Sentry-Auth')
        if not auth:
            self._404()
            return

        sentry_key = SENTRY_KEY.search(auth)
        if not sentry_key:
            self._404()
            return

        sentry_key = sentry_key.groups()[0]

        sentry_secret = SENTRY_SECRET.search(auth)
        if not sentry_secret:
            self._404()
            return

        sentry_secret = sentry_secret.groups()[0]

        for _project_id, keys in self.application.project_keys.iteritems():
            if sentry_key in keys['public_key'] and sentry_secret in keys['secret_key']:
                project_id = _project_id
                break

        if project_id is None:
            self._404()
            return

        base_url = self.application.config.SENTRY_BASE_URL.replace('http://', '').replace('https://', '')
        base_url = "%s://%s:%s@%s" % (self.request.protocol, sentry_key, sentry_secret, base_url)
        url = "%s%s?%s" % (base_url, self.request.path, self.request.query)

        try:
            payload = loads(self.request.body)
        except ValueError:
            payload = loads(decompress(b64decode(self.request.body)))

        if 'culprit' in payload:
            message_key = payload['culprit']
        else:
            message_key = payload['message']

        cache_key = "%s:%s" % (project_id, message_key)
        count = self.validate_cache(cache_key)
        if count > self.application.config.MAX_CACHE_USES:
            return

        self.set_header("X-CYCLOPS-CACHE-COUNT", str(count))
        self.set_header("X-CYCLOPS-STATUS", "PROCESSED")
        self.application.processed_items += 1

        self.process_request(project_id, url)

    def frontend_request(self, project_id):
        if int(project_id) not in self.application.project_keys:
            self._404()
            return

        project_id = int(project_id)

        sentry_key = self.get_argument('sentry_key')
        if not sentry_key.strip() in self.application.project_keys[project_id]["public_key"]:
            self.set_status(403)
            self.write("INVALID KEY")
            self.finish()
            return

        url = "%s%s?%s" % (self.application.config.SENTRY_BASE_URL, self.request.path, self.request.query)

        if project_id in self.application.config.IGNORE_PERCENTAGE:
            value = randint(1, 100)

            if value < int(self.application.config.IGNORE_PERCENTAGE[project_id]):
                self.set_status(304)
                self.set_header("X-CYCLOPS-STATUS", "IGNORED")
                self.application.ignored_items += 1
                self.finish()
                return

        count = self.validate_cache(url)
        if count > self.application.config.MAX_CACHE_USES:
            return

        self.set_header("X-CYCLOPS-CACHE-COUNT", str(count))
        self.set_header("X-CYCLOPS-STATUS", "PROCESSED")
        self.application.processed_items += 1
        self.process_request(project_id, url)



class RouterHandler(BaseRouterHandler):
    @tornado.web.asynchronous
    def get(self, project_id):
        self.frontend_request(project_id)

    @tornado.web.asynchronous
    def post(self, project_id=None):
        self.backend_request(project_id)

class OldRouterHandler(BaseRouterHandler):
    @tornado.web.asynchronous
    def post(self):
        self.backend_request()


class CountHandler(BaseHandler):
    @tornado.web.asynchronous
    def get(self):
        total_count = self.application.storage.total_size
        result = {
            'count': total_count,
            'average': self.application.average_request_time,
            'percentile': self.application.percentile_request_time,
            'processed': self.application.processed_items,
            'ignored': self.application.ignored_items
        }
        self.write(dumps(result))
        self.finish()
