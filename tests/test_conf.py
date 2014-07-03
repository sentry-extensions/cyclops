#!/usr/bin/env python
# -*- coding: utf-8 -*-

from preggy import expect

from cyclops.config import Config
from cyclops.projects import ProjectLoader

def test_project_keys_without_mysql():
    config = Config()
    config.PROJECT_KEYS = [
        (1, "public1", "secret1"),
        (2, "public2", "secret2"),
        (1, "public1.2", "secret1.2"),
    ]
    config.MYSQL_HOST = None
    project_loader = ProjectLoader(config)
    project_keys = project_loader.get_project_keys()
    expect(project_keys).to_equal({
        1: {"public_key": ["public1", "public1.2"], "secret_key": ["secret1", "secret1.2"]},
        2: {"public_key": ["public2"], "secret_key": ["secret2"]},
    })
