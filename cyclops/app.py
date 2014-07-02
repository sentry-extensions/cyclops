#!/usr/bin/python
# -*- coding: utf-8 -*-

import logging
#from Queue import Queue, LifoQueue
#from collections import defaultdict

import tornado.web
from tornado.httpclient import AsyncHTTPClient
from tornado.web import url

from cyclops.handlers.router import OldRouterHandler, RouterHandler, CountHandler
from cyclops.handlers.healthcheck import HealthCheckHandler
from cyclops.tasks import ProjectsUpdateTask, SendToSentryTask


def get_class(module_name):
    if '.' not in module_name:
        return __import__(module_name)

    modules = module_name.split('.')
    return reduce(getattr, modules[1:], __import__(".".join(modules[:-1])))


class BaseApp(object):

    def __init__(self, config=None, debug=False, main_loop=None, configure=True):
        self.config = config
        self.main_loop = main_loop
        self.storage = None
        self.project_keys = None
        self.processed_items = None
        self.ignored_items = None
        self.last_requests = None
        self.average_request_time = None
        self.percentile_request_time = None
        self.cache = None
        if configure:
            self.configure(debug=debug)

    def configure(self, debug=False):
        if debug:
            self.config.NUMBER_OF_FORKS = 1
        logging.info("Connecting to db on {0}:{1} on database {2} with user {3}".format(
            self.config.MYSQL_HOST,
            self.config.MYSQL_PORT,
            self.config.MYSQL_DB,
            self.config.MYSQL_USER)
        )

        cache_class = get_class(self.config.CACHE_IMPLEMENTATION_CLASS)
        self.cache = cache_class(self)

        storage_class = get_class(self.config.STORAGE)
        self.storage = storage_class(self)

        self.project_keys = {}

        self.processed_items = 0
        self.ignored_items = 0

        self.last_requests = []
        self.average_request_time = None
        self.percentile_request_time = None

        projects_update_task = ProjectsUpdateTask(self, self.main_loop)
        projects_update_task.update()
        projects_update_task.start()

        send_to_sentry_task = SendToSentryTask(self, self.main_loop)
        send_to_sentry_task.update()
        send_to_sentry_task.start()

        AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")

    def get_handlers(self):
        return [
            url(r'/api/(?P<project_id>\d+)/store/', RouterHandler, name="router"),
            # Deprecated
            url(r'/api/store/', OldRouterHandler, name="router_post"),
            #/Deprecated
            url(r'/count', CountHandler, name="count"),
            url(r'/healthcheck(?:/|\.html)?', HealthCheckHandler, name="healthcheck"),
        ]


class CyclopsApp(BaseApp, tornado.web.Application):

    def __init__(self, config=None, debug=False, main_loop=None, configure=True):
        super(CyclopsApp, self).__init__(config=config, debug=debug, main_loop=main_loop, configure=configure)
        tornado.web.Application.__init__(self, self.get_handlers(), debug=debug)
