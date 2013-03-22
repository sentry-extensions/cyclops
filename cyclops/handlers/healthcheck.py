#!/usr/bin/python
# -*- coding: utf-8 -*-

import tornado.web

from cyclops.handlers.base import BaseHandler


class HealthCheckHandler(BaseHandler):

    @tornado.web.asynchronous
    def get(self):
        self.set_status(200)
        self.write(self.application.config.HEALTHCHECK_TEXT)
        self.finish()
