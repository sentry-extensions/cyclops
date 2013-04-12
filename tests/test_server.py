#!/usr/bin/env python
# -*- coding: utf-8 -*-

_multiprocess_can_split_ = True

from preggy import *

from cyclops.server import LOGS, ROOT_PATH, DEFAULT_CONFIG_PATH, main


def test_server_logs_values():
    expect(LOGS).to_include(0)
    expect(LOGS[0]).to_equal("error")

    #LOGS = {
        #0: 'error',
        #1: 'warning',
        #2: 'info',
        #3: 'debug'
    #}


    #assert True
