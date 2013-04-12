#!/usr/bin/env python
# -*- coding: utf-8 -*-

_multiprocess_can_split_ = True

from preggy import *

from cyclops.server import LOGS, ROOT_PATH, DEFAULT_CONFIG_PATH, main


def test_server_logs_values():
    expect(LOGS).to_include(0)
    expect(LOGS[0]).to_equal("error")

    expect(LOGS).to_include(1)
    expect(LOGS[1]).to_equal("warning")

    expect(LOGS).to_include(2)
    expect(LOGS[2]).to_equal("info")

    expect(LOGS).to_include(3)
    expect(LOGS[3]).to_equal("debug")
