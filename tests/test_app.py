#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import os.path
from collections import defaultdict
from Queue import LifoQueue, Queue

from preggy import expect
from torndb import Connection
from tornado.ioloop import IOLoop
from tornado.testing import AsyncHTTPTestCase

from cyclops.app import get_class, configure_app, CyclopsApp
from cyclops.storage import InMemoryStorage
from cyclops.cache import RedisCache
from tests.helpers import FakeLoop, App, forget, get_config


def test_get_class():
    expect(get_class('os')).to_equal(os)
    expect(get_class('os.path')).to_equal(os.path)


def test_configure_app():
    app = App()
    cfg = get_config()

    loop = FakeLoop()
    handlers, options = configure_app(app, config=cfg, log_level='WARNING', debug=True, main_loop=loop)

    expect(app.main_loop).to_equal(loop)
    expect(app.config).to_equal(cfg)

    expect(handlers).to_length(4)
    expect(handlers[0].name).to_equal('router')
    expect(handlers[1].name).to_equal('router_post')
    expect(handlers[2].name).to_equal('count')
    expect(handlers[3].name).to_equal('healthcheck')

    expect(app.db).to_be_instance_of(Connection)
    expect(app.db.database).to_equal('sentry_tests')

    expect(app.cache).to_be_instance_of(RedisCache)
    expect(app.cache.application).to_equal(app)

    expect(app.storage).to_be_instance_of(InMemoryStorage)
    expect(app.storage.application).to_equal(app)
    expect(app.storage.items_to_process).to_be_instance_of(defaultdict)
    expect(app.storage.items_to_process.default_factory).to_equal(LifoQueue)

    expect(app.project_keys).to_length(1)

    expect(app.processed_items).to_equal(0)
    expect(app.ignored_items).to_equal(0)

    expect(app.last_requests).to_be_empty()

    expect(app.average_request_time).to_be_null()
    expect(app.percentile_request_time).to_be_null()

    expect(options).to_length(1)
    expect(options['debug']).to_be_true()

    expect(cfg.NUMBER_OF_FORKS).to_equal(1)

    forget()


def test_configure_app_to_FifoQueue():
    app = App()
    cfg = get_config(PROCESS_NEWER_MESSAGES_FIRST=False)

    loop = FakeLoop()
    handlers, options = configure_app(app, config=cfg, log_level='WARNING', debug=True, main_loop=loop)

    expect(app.storage.items_to_process).to_be_instance_of(defaultdict)
    expect(app.storage.items_to_process.default_factory).to_equal(Queue)

    forget()


class TestCyclopsApp(AsyncHTTPTestCase):
    def get_app(self):
        cfg = get_config()
        return CyclopsApp(config=cfg, main_loop=IOLoop.current())

    def test_healthcheck(self):
        response = self.fetch('/healthcheck')
        expect(response.body).to_equal("WORKING")
