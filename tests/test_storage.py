#!/usr/bin/env python
# -*- coding: utf-8 -*-

from preggy import expect

from cyclops.storage import InMemoryStorage, RedisStorage
from tests.helpers import App, get_config


def get_app():
    cfg = get_config(REDIS_HOST='localhost', REDIS_PORT=7780, REDIS_DB_COUNT=0, REDIS_PASSWORD=None)
    return App(config=cfg)


def test_in_memory_storage_putting_item():
    app = get_app()
    storage = InMemoryStorage(app)

    storage.put(project_id=10, message={
        "test": "test2"
    })

    storage.put(project_id=20, message={
        "test": "test2"
    })

    expect(storage.get_size(10)).to_equal(1)
    expect(storage.get_size(20)).to_equal(1)
    expect(storage.total_size).to_equal(2)


def test_in_memory_storage_get_next_when_no_projects():
    app = get_app()
    storage = InMemoryStorage(app)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_null()


def test_in_memory_storage_get_next_when_empty():
    app = get_app()
    storage = InMemoryStorage(app)

    storage.put(project_id=20, message={
        "test": "test2"
    })

    storage.get_next_message()
    retrieved = storage.get_next_message()

    expect(retrieved).to_be_null()


def test_in_memory_storage_get_next():
    app = get_app()
    storage = InMemoryStorage(app)

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_like(msg)


def test_in_memory_storage_mark_as_done():
    app = get_app()
    storage = InMemoryStorage(app)

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_like(msg)
    storage.mark_as_done(10)


def test_redis_storage_putting_item():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    storage.put(project_id=10, message={
        "test": "test2"
    })

    storage.put(project_id=20, message={
        "test": "test2"
    })

    expect(storage.get_size(10)).to_equal(1)
    expect(storage.get_size(20)).to_equal(1)
    expect(storage.total_size).to_equal(2)


def test_redis_storage_get_next_when_no_projects():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_null()


def test_redis_storage_get_next_when_empty():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    storage.put(project_id=20, message={
        "test": "test2"
    })

    storage.get_next_message()
    retrieved = storage.get_next_message()

    expect(retrieved).to_be_null()


def test_redis_storage_get_next():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_like(msg)


def test_redis_storage_mark_as_done():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_like(msg)
    storage.mark_as_done(10)


def test_redis_storage_available_queues():
    app = get_app()
    storage = RedisStorage(app)
    storage.clear()

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)
    storage.put(project_id=20, message=msg)

    expect(storage.available_queues).to_be_like(["10", "20"])


def test_redis_storage_fails_if_not_configured_properly():
    cfg = get_config(REDIS_HOST=None, REDIS_PORT=7780, REDIS_DB_COUNT=0, REDIS_PASSWORD=None)
    app = App(config=cfg)

    try:
        RedisStorage(app)
    except RuntimeError, err:
        msg = "If you are using RedisStorage you need to set in your configuration file " \
            "the following keys: REDIS_HOST, REDIS_PORT, REDIS_DB_COUNT and REDIS_PASSWORD(optional)"
        expect(err).to_have_an_error_message_of(msg)
        return

    assert False, "Should not have gotten this far"
