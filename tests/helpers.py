#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time


class FakeLoop(object):
    def __init__(self):
        self.started = False
        self.timeouts = []

    def start(self):
        self.started = True

    def time(self):
        return time.time()

    def add_timeout(self, time, callback):
        self.timeouts.append((time, callback))


class FakeServer(object):
    called_with = {}

    def __init__(self, application, xheaders):
        self.application = application
        self.xheaders = xheaders

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


class App(object):
    called_with = {}

    def __init__(self, config=None, log_level='info', debug=False, main_loop=None):
        self.config = config
        self.log_level = log_level
        self.debug = debug
        self.main_loop = main_loop

        App.called_with['config'] = config
        App.called_with['log_level'] = log_level
        App.called_with['debug'] = debug
        App.called_with['main_loop'] = main_loop

    @classmethod
    def forget(cls):
        App.called_with = {}


def forget():
    App.forget()
    FakeServer.forget()
