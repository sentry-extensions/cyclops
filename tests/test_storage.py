#!/usr/bin/env python
# -*- coding: utf-8 -*-

from preggy import expect

from cyclops.storage import InMemoryStorage
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


def test_in_memory_storage_get_next():
    app = get_app()
    storage = InMemoryStorage(app)

    msg = {
        "test": "test2"
    }

    storage.put(project_id=10, message=msg)

    retrieved = storage.get_next_message()

    expect(retrieved).to_be_like(msg)
