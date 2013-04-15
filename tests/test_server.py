#!/usr/bin/env python
# -*- coding: utf-8 -*-

_multiprocess_can_split_ = True

from os.path import abspath, join, dirname

from preggy import expect

from cyclops.server import LOGS, ROOT_PATH, DEFAULT_CONFIG_PATH, main

EXPECTED_ROOT_PATH = abspath(join(dirname(__file__), '..'))
EXPECTED_DEFAULT_CONFIG_PATH = join(ROOT_PATH, 'cyclops', 'local.conf')


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
