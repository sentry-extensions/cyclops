#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time

from cyclops.config import Config
from cyclops.app import BaseApp


class FakeLoop(object):
    def __init__(self):
        self.started = False
        self.timeouts = []

    def start(self):
        self.started = True

    def time(self):
        return time.time()

    def add_timeout(self, at_time, callback):
        self.timeouts.append((at_time, callback))


class FakeServer(object):
    called_with = {}

    def __init__(self, application, xheaders):
        self.application = application
        self.xheaders = xheaders
        self.port = None
        self.ip = None

        FakeServer.called_with['application'] = application
        FakeServer.called_with['xheaders'] = xheaders

    @classmethod
    def forget(cls):
        FakeServer.called_with = {}

    def bind(self, port, ip):
        self.port = port
        self.ip = ip
        self.called_with['port'] = port
        self.called_with['ip'] = ip

    def start(self, procs):
        FakeServer.called_with['procs'] = procs


class App(BaseApp):
    called_with = {}

    def __init__(self, config=None, debug=False, main_loop=None, configure=False):
        super(App, self).__init__(config=config, debug=debug, main_loop=main_loop, configure=configure)

        App.called_with['config'] = config
        App.called_with['debug'] = debug
        App.called_with['main_loop'] = main_loop

    @classmethod
    def forget(cls):
        App.called_with = {}


def forget():
    App.forget()
    FakeServer.forget()


def get_config(*args, **kw):
    if not kw:
        kw = {}
    kw['MYSQL_DB'] = 'sentry_tests'

    return Config(**kw)
