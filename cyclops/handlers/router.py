#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
from zlib import decompress
from base64 import b64decode
from random import randint

import tornado.web
from ujson import dumps, loads
from cyclops.hash_calculator import hash_for_grouping
#import msgpack

from cyclops.handlers.base import BaseHandler

SENTRY_KEY = re.compile(r'sentry_key\=(.+),')
SENTRY_SECRET = re.compile(r'sentry_secret\=(.+),?')


class BaseRouterHandler(BaseHandler):

    def _404(self):
        self.set_status(404)
        self.finish()

    def _403(self):
        self.set_status(403)
        self.write("INVALID KEY")
        self.finish()

    def send_ignored_response(self):
        self.set_header("X-CYCLOPS-STATUS", "IGNORED")
        self.application.ignored_items += 1
        self.write("IGNORED")
        self.finish()

    def send_processed_response(self):
        self.set_header("X-CYCLOPS-STATUS", "PROCESSED")
        self.application.processed_items += 1
        self.set_status(200)
        self.write("OK")
        self.finish()

    def validate_percentage_ignore(self, project_id):
        is_ignored = False
        if project_id in self.application.config.IGNORE_PERCENTAGE:
            value = randint(1, 100)
            if value < int(self.application.config.IGNORE_PERCENTAGE[project_id]):
                self.send_ignored_response()
                is_ignored = True

        return is_ignored

    def get_cache_key(self, project_id, request_body):
        try:
            payload = loads(request_body)
        except ValueError:
            payload = loads(decompress(b64decode(request_body)))

        message_key = hash_for_grouping(payload)
        cache_key = "%s:%s" % (project_id, message_key)
        return cache_key

    def validate_cache(self, project_id, request_body):
        is_ignored = False

        if self.application.config.URL_CACHE_EXPIRATION > 0:
            cache_key = self.get_cache_key(project_id, request_body)

            if self.application.cache.get(cache_key) is None:
                self.application.cache.set(cache_key, self.application.config.URL_CACHE_EXPIRATION)

            count = self.application.cache.incr(cache_key)
            self.set_header("X-CYCLOPS-CACHE-COUNT", str(count))

            if count > self.application.config.MAX_CACHE_USES:
                self.send_ignored_response()
                is_ignored = True

        return is_ignored

    def validate_project_by_public_dsn(self, project_id):
        is_accessible = True

        if self.application.config.RESTRICT_API_ACCESS:
            # check project in restrict api list
            if int(project_id) not in self.application.project_keys:
                self._404()
                is_accessible = False

            # check public key
            sentry_key = self.get_argument('sentry_key').strip()
            if sentry_key not in self.application.project_keys[project_id]["public_key"]:
                self._403()
                is_accessible = False

        return is_accessible

    def process_request(self, project_id, url):
        headers = {}
        body = self.request.body
        for k, v in sorted(self.request.headers.get_all()):
            headers[k] = v

        message = (
            project_id,
            self.request.method,
            headers,
            url,
            body
        )

        self.application.storage.put(project_id, message)
        self.send_processed_response()

    def handle_backend_post_request(self, project_id=None):
        # check if auth token passed
        auth = self.request.headers.get('X-Sentry-Auth')
        if not auth:
            self._404()
            return

        # check if auth key valid
        sentry_key = SENTRY_KEY.search(auth)
        if not sentry_key:
            self._404()
            return

        sentry_key = sentry_key.groups()[0]

        # check if auth secret valid
        sentry_secret = SENTRY_SECRET.search(auth)
        if not sentry_secret:
            self._404()
            return

        sentry_secret = sentry_secret.groups()[0]

        # get project
        if project_id is None:
            project_id = self.get_project_id(sentry_key, sentry_secret)
        else:
            project_id = int(project_id)

        # check project in restrict api list
        if self.application.config.RESTRICT_API_ACCESS:
            if project_id is None or not self.are_valid_keys(project_id, sentry_key, sentry_secret):
                self._404()
                return

        # check cache usage
        if self.validate_cache(project_id, self.request.body):
            return

        # handle request
        base_url = self.application.config.SENTRY_BASE_URL.replace('http://', '').replace('https://', '')
        base_url = "%s://%s:%s@%s" % (self.request.protocol, sentry_key, sentry_secret, base_url)
        url = "%s%s?%s" % (base_url, self.request.path, self.request.query)
        self.process_request(project_id, url)

    def get_project_id(self, public_key, secret_key):
        for project_id, keys in self.application.project_keys.iteritems():
            if public_key in keys['public_key'] and secret_key in keys['secret_key']:
                return project_id
        return None

    def are_valid_keys(self, project_id, public_key, secret_key):
        keys = self.application.project_keys.get(project_id)
        if keys is None:
            return False

        return public_key in keys['public_key'] and secret_key in keys['secret_key']

    def handle_frontend_post_request(self, project_id):
        # CORS headers
        origin = self.request.headers.get('Origin')
        if origin:
            self.set_header("Access-Control-Allow-Headers", "X-Sentry-Auth, X-Requested-With, Origin, Accept, Content-Type, Authentication")
            self.set_header("Access-Control-Allow-Methods", "GET, POST, HEAD, OPTIONS")
            self.set_header("Access-Control-Allow-Origin", origin)
            self.set_header("Access-Control-Expose-Headers", "X-Sentry-Error, Retry-After")

        # check project accessibility
        project_id = int(project_id)
        if not self.validate_project_by_public_dsn(project_id):
            return

        # ignore by percentage
        if self.validate_percentage_ignore(project_id):
            return

        # check cache usage
        if self.validate_cache(project_id, self.request.body):
            return

        # handle request
        url = "%s%s?%s" % (self.application.config.SENTRY_BASE_URL, self.request.path, self.request.query)
        self.process_request(project_id, url)

    def handle_frontend_get_request(self, project_id):
        # check project accessibility
        project_id = int(project_id)
        if not self.validate_project_by_public_dsn(project_id):
            return

        # ignore by percentage
        if self.validate_percentage_ignore(project_id):
            return

        # check cache usage
        if self.validate_cache(project_id, self.get_argument('sentry_data')):
            return

        # handle request
        url = "%s%s?%s" % (self.application.config.SENTRY_BASE_URL, self.request.path, self.request.query)
        self.process_request(project_id, url)


class RouterHandler(BaseRouterHandler):
    @tornado.web.asynchronous
    def get(self, project_id=None):
        self.handle_frontend_get_request(project_id)

    @tornado.web.asynchronous
    def post(self, project_id=None):
        auth = self.request.headers.get('X-Sentry-Auth')
        if auth:
            # backend client uses private DSN and sends key and secret in X-Sentry-Auth header
            self.handle_backend_post_request(project_id)
        else:
            # browser based client uses public DSN and sends only key in QUERY_STRING
            self.handle_frontend_post_request(project_id)

class OldRouterHandler(BaseRouterHandler):
    @tornado.web.asynchronous
    def post(self):
        self.handle_backend_post_request()


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
