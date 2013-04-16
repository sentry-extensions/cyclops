#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from preggy import expect

from cyclops.cache import Cache, NoCache, RedisCache
from tests.helpers import App, get_config


def get_app():
    cfg = get_config(REDIS_HOST='localhost', REDIS_PORT=7780, REDIS_DB_COUNT=0, REDIS_PASSWORD=None)
    return App(config=cfg)


def test_cache_get_return_none():
    app = get_app()
    cache = Cache(app)

    expect(cache.get("SOMETHING")).to_be_null()


def test_cache_set_does_nothing():
    app = get_app()
    cache = Cache(app)

    expect(cache.set("SOMETHING", 10)).to_be_null()


def test_no_cache_get_return_none():
    app = get_app()
    cache = NoCache(app)

    expect(cache.get("SOMETHING")).to_be_null()


def test_no_cache_set_does_nothing():
    app = get_app()
    cache = NoCache(app)

    expect(cache.set("SOMETHING", 10)).to_be_null()


def test_redis_cache_get_return_none_if_null_key():
    app = get_app()
    cache = RedisCache(app)

    expect(cache.get("ELSE")).to_be_null()


def test_redis_cache_sets_key():
    app = get_app()
    cache = RedisCache(app)

    cache.set("SOMETHING", 10)

    expect(cache.get("SOMETHING")).to_equal(0)


def test_redis_cache_incr():
    app = get_app()
    cache = RedisCache(app)

    cache.set("SOMETHING", 10)

    cache.incr("SOMETHING")
    cache.incr("SOMETHING")
    cache.incr("SOMETHING")
    cache.incr("SOMETHING")
    cache.incr("SOMETHING")

    expect(cache.get("SOMETHING")).to_equal(5)
