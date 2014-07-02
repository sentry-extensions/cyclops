#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
from torndb import Connection

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

                if not project.project_id in project_keys:
                    project_keys[project.project_id] = {
                        "public_key": [],
                        "secret_key": []
                    }

                project_keys[project.project_id]['public_key'].append(project.public_key)
                project_keys[project.project_id]['secret_key'].append(project.secret_key)
        finally:
            db.close()
        return project_keys
