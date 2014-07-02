#!/usr/bin/env python
# -*- coding: utf-8 -*-

from os.path import abspath, join, dirname

from preggy import expect
from tornado.ioloop import IOLoop

from cyclops.server import LOGS, ROOT_PATH, DEFAULT_CONFIG_PATH, main, get_ioloop
from tests.helpers import FakeLoop, FakeServer, App, forget

EXPECTED_ROOT_PATH = abspath(join(dirname(__file__), '..'))
EXPECTED_DEFAULT_CONFIG_PATH = join(ROOT_PATH, 'cyclops', 'local.conf')


def test_get_ioloop():
    expect(get_ioloop()).to_equal(IOLoop.current())


def test_server_logs_values():
    expect(LOGS).to_include(0)
    expect(LOGS[0]).to_equal("error")

    expect(LOGS).to_include(1)
    expect(LOGS[1]).to_equal("warning")

    expect(LOGS).to_include(2)
    expect(LOGS[2]).to_equal("info")

    expect(LOGS).to_include(3)
    expect(LOGS[3]).to_equal("debug")


def test_paths():
    expect(ROOT_PATH).to_equal(EXPECTED_ROOT_PATH)
    expect(DEFAULT_CONFIG_PATH).to_equal(EXPECTED_DEFAULT_CONFIG_PATH)


def test_main_works_as_expected():
    argv = []
    main_loop = FakeLoop()

    main(args=argv, main_loop=main_loop, app=App, server_impl=FakeServer)

    expect(App.called_with).to_include('config')
    expect(App.called_with).to_include('debug')
    expect(App.called_with).to_include('main_loop')

    expect(App.called_with['debug']).to_be_false()

    expect(main_loop.started).to_be_true()

    expect(FakeServer.called_with).to_include('application')
    expect(FakeServer.called_with['application']).to_be_instance_of(App)
    expect(FakeServer.called_with).to_include('xheaders')
    expect(FakeServer.called_with['xheaders']).to_be_true()

    expect(FakeServer.called_with).to_include('port')
    expect(FakeServer.called_with['port']).to_equal(9999)

    expect(FakeServer.called_with).to_include('ip')
    expect(FakeServer.called_with['ip']).to_equal("0.0.0.0")

    expect(FakeServer.called_with).to_include('procs')
    expect(FakeServer.called_with['procs']).to_equal(1)

    forget()


def test_main_with_debug():
    argv = ['--debug']
    main_loop = FakeLoop()

    main(args=argv, main_loop=main_loop, app=App, server_impl=FakeServer)

    expect(App.called_with).to_include('debug')
    expect(App.called_with['debug']).to_be_true()

    forget()


def test_main_with_port_and_bind():
    argv = ['--port', '7654', '--bind', '1.2.3.4']
    main_loop = FakeLoop()

    main(args=argv, main_loop=main_loop, app=App, server_impl=FakeServer)

    expect(FakeServer.called_with).to_include('port')
    expect(FakeServer.called_with['port']).to_equal(7654)

    expect(FakeServer.called_with).to_include('ip')
    expect(FakeServer.called_with['ip']).to_equal("1.2.3.4")

    forget()


def test_main_with_custom_config():
    working_text = "GNIKROW"
    argv = ['--conf', './tests/test.conf']
    main_loop = FakeLoop()

    main(args=argv, main_loop=main_loop, app=App, server_impl=FakeServer)

    expect(App.called_with).to_include('config')
    expect(App.called_with['config'].HEALTHCHECK_TEXT).to_equal(working_text)

    forget()


def get_fake_ioloop(loop):
    def get_loop():
        return loop

    return get_loop


def test_main_with_no_ioloop():
    argv = []
    loop = FakeLoop()

    main(args=argv, main_loop=None, app=App, server_impl=FakeServer, get_ioloop=get_fake_ioloop(loop))

    forget()
