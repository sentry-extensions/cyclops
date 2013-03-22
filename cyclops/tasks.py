#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Queue

from tornado.ioloop import PeriodicCallback
from tornado.httpclient import AsyncHTTPClient, HTTPRequest


class ProjectsUpdateTask(object):
    def __init__(self, application, main_loop):
        self.application = application
        self.main_loop = main_loop
        self.db = self.application.db

    def start(self):
        periodic_task = PeriodicCallback(
            self.update,
            self.application.config.UPDATE_PERIOD * 1000,
            io_loop=self.main_loop
        )
        periodic_task.start()

    def update(self):
        query = "select project_id, public_key, secret_key from sentry_projectkey"
        logging.info("Executing query %s in MySQL" % query)

        for project in self.db.query(query):
            logging.info("Updating information for project with id %s..." % project.project_id)
            self.application.project_keys[project.project_id] = {
                "public_key": project.public_key,
                "secret_key": project.secret_key
            }


class SendToSentryTask(object):
    def __init__(self, application, main_loop):
        self.application = application
        self.main_loop = main_loop

    def start(self):
        periodic_task = PeriodicCallback(
            self.update,
            100,
            io_loop=self.main_loop
        )
        periodic_task.start()

    def handle_request(self, response):
        if response.error:
            logging.error("Error: %s" % response.error)
        else:
            logging.debug("OK")

    def update(self):
        try:
            method, headers, url = self.application.items_to_process.get_nowait()

            request = HTTPRequest(url=url, headers=headers, method=method)

            logging.info("Sending to sentry at %s" % url)
            http_client = AsyncHTTPClient(io_loop=self.main_loop)
            http_client.fetch(request, self.handle_request)
            self.application.items_to_process.task_done()
        except Queue.Empty:
            pass
