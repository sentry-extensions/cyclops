#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging

class ProjectLoader(object):

    def __init__(self, config):
        self.config = config

    def log_info(self):
        logging.info("Connecting to db on {0}:{1} on database {2} with user {3}".format(
            self.config.MYSQL_HOST,
            self.config.MYSQL_PORT,
            self.config.MYSQL_DB,
            self.config.MYSQL_USER)
        )

    def get_project_keys(self):
        project_keys = {}
        if self.config.MYSQL_HOST is not None:
            project_keys.update(self.get_project_keys_from_mysql())
        elif self.config.PROJECT_KEYS is not None:
            project_keys.update(self.get_project_keys_from_list())
        if len(project_keys) == 0:
            logging.warning("Empty project key list. You must either fill your"
                    "MySQL project database or manually define the PROJECT_KEYS"
                    "configuration variable")
        return project_keys

    def get_project_keys_from_mysql(self):
        from torndb import Connection
        db = Connection(
            "%s:%s" % (self.config.MYSQL_HOST, self.config.MYSQL_PORT),
            self.config.MYSQL_DB,
            user=self.config.MYSQL_USER,
            password=self.config.MYSQL_PASS
        )

        query = "select project_id, public_key, secret_key from sentry_projectkey"
        logging.info("Executing query %s in MySQL", query)

        project_keys = {}

        try:
            db_projects = db.query(query)

            if db_projects is None:
                return None

            for project in db_projects:
                logging.info("Updating information for project with id %s...", project.project_id)
                self.add_project(project_keys, project.project_id, project.public_key, project.secret_key)

        finally:
            db.close()
        return project_keys

    def get_project_keys_from_list(self):
        project_keys = {}
        for project_id, public_key, secret_key in self.config.PROJECT_KEYS:
            self.add_project(project_keys, project_id, public_key, secret_key)
        return project_keys

    @staticmethod
    def add_project(project_keys, project_id, public_key, secret_key):
        if not project_id in project_keys:
            project_keys[project_id] = {
                "public_key": [],
                "secret_key": []
            }
        project_keys[project_id]['public_key'].append(public_key)
        project_keys[project_id]['secret_key'].append(secret_key)
