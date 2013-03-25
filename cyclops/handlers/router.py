#!/usr/bin/python
# -*- coding: utf-8 -*-

import re

import tornado.web
from ujson import dumps
import msgpack

from cyclops.handlers.base import BaseHandler

SENTRY_KEY = re.compile(r'sentry_key\=(.+),')
SENTRY_SECRET = re.compile(r'sentry_secret\=(.+),?')


class RouterHandler(BaseHandler):

    def _404(self):
        self.set_status(404)
        self.finish()

    @tornado.web.asynchronous
    def get(self, project_id):
        if int(project_id) not in self.application.project_keys:
            self.set_status(404)
            self.finish()
            return

        project_id = int(project_id)

        sentry_key = self.get_argument('sentry_key')
        if sentry_key.strip() != self.application.project_keys[project_id]["public_key"]:
            self.set_status(403)
            self.write("INVALID KEY")
            self.finish()
            return

        url = "%s%s?%s" % (self.application.config.SENTRY_BASE_URL, self.request.path, self.request.query)

        self.process_request(project_id, url)

    @tornado.web.asynchronous
    def post(self):
        auth = self.request.headers.get('X-Sentry-Auth')

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

        project_id = None
        for _project_id, keys in self.application.project_keys.iteritems():
            if keys['public_key'] == sentry_key and keys['secret_key'] == sentry_secret:
                project_id = _project_id
                break

        if project_id is None:
            self._404()
            return

        base_url = self.application.config.SENTRY_BASE_URL.replace('http://', '').replace('https://', '')
        base_url = "%s://%s:%s@%s" % (self.request.protocol, sentry_key, sentry_secret, base_url)
        url = "%s%s?%s" % (base_url, self.request.path, self.request.query)

        self.process_request(project_id, url)

    def process_request(self, project_id, url):
        headers = self.request.headers
        body = self.request.body

        message = (
            self.request.method,
            headers,
            url,
            body
        )

        self.application.items_to_process.put(msgpack.packb(message))

        self.set_status(200)
        self.write("OK")
        self.finish()


class CountHandler(BaseHandler):
    @tornado.web.asynchronous
    def get(self):
        result = {
            'count': self.application.items_to_process.qsize(),
            'average': self.application.average_request_time,
            'percentile': self.application.percentile_request_time
        }
        self.write(dumps(result))
        self.finish()
