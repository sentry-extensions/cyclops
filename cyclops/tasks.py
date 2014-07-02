#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Queue
import time

from tornado.ioloop import PeriodicCallback
from tornado.httpclient import AsyncHTTPClient, HTTPRequest


MAX_TRIES = 10


class ProjectsUpdateTask(object):
    def __init__(self, application, main_loop):
        self.application = application
        self.main_loop = main_loop

    def start(self):
        periodic_task = PeriodicCallback(
            self.update,
            self.application.config.UPDATE_PERIOD * 1000,
            io_loop=self.main_loop
        )
        periodic_task.start()

    def update(self):
        if self.application.load_project_keys() is None:
            logging.warn("Could not retrieve information from sentry's "
                    "database because MySQL Server was unavailable")


class SendToSentryTask(object):
    def __init__(self, application, main_loop):
        self.application = application
        self.main_loop = main_loop
        self.start_time = None
        self.last_sent = None

    def start(self):
        periodic_task = PeriodicCallback(
            self.update,
            20,
            io_loop=self.main_loop
        )
        periodic_task.start()

    def get_handle_request(self, project_id):
        def handle_request(response):
            response_time = response.request_time
            logging.debug("Request handled in %.2f", response_time)
            self.application.last_requests.append(response_time)
            self.application.last_requests = self.application.last_requests[
                max(0, len(self.application.last_requests) - self.application.config.MAX_REQUESTS_TO_AVERAGE):]
            self.application.average_request_time = self.mean(self.application.last_requests) * 1000
            self.application.percentile_request_time = self.calculate_percentile() * 1000

            self.application.storage.mark_as_done(project_id)
            #self.application.items_to_process[project_id].task_done()

            if response.error:
                logging.error("Error: %s", response.error)
            else:
                logging.debug("OK")
        return handle_request

    def update(self):
        try:
            app_request_time = self.application.percentile_request_time is None and \
                self.application.config.MAX_DUMP_INTERVAL or \
                min(self.application.percentile_request_time, self.application.config.MAX_DUMP_INTERVAL)

            logging.debug("Actual App Request Time: %.2fms", app_request_time)
            if self.application.percentile_request_time:
                logging.debug("Percentile Request Time: %.2f ms", self.application.percentile_request_time)
            if self.last_sent:
                logging.debug("Last Sent: %d", self.last_sent)
                logging.debug("Now - Last Sent: %d", (time.time() - self.last_sent))

            if self.application.percentile_request_time is not None and \
                    self.last_sent is not None and \
                    time.time() - self.last_sent < (self.application.percentile_request_time / 1000):
                return

            #if not self.application.items_to_process.keys():
            if not self.application.storage.total_size:
                return

            logging.debug(
                "Getting a message at random from one of the available queues: [%s]",
                ", ".join(self.application.storage.available_queues)
            )

            msg = self.application.storage.get_next_message()
            if not msg:
                return

            project_id, method, headers, url, body = msg

            request = HTTPRequest(url=url, headers=headers, method=method, body=body)

            logging.debug("Sending to sentry at %s", url)
            self.start_time = time.time()
            self.last_sent = time.time()
            http_client = AsyncHTTPClient(io_loop=self.main_loop)
            http_client.fetch(request, self.get_handle_request(project_id))
        except Queue.Empty:
            pass

    def mean(self, items):
        return float(sum(items)) / len(items) if len(items) > 0 else float(0)

    def calculate_percentile(self):
        logging.debug("Length of Last Requests: %d", len(self.application.last_requests))
        sorted_times = list(reversed(sorted(self.application.last_requests)))
        last_message = int(round(len(self.application.last_requests) * 0.9))
        return self.mean(sorted_times[len(self.application.last_requests) - last_message:])
