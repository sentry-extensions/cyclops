#!/usr/bin/python
# -*- coding: utf-8 -*-

import tornado.web

from cyclops.handlers.base import BaseHandler


class RouterHandler(BaseHandler):

    @tornado.web.asynchronous
    def get(self, project_id):
        if int(project_id) not in self.application.project_keys:
            self.set_status(404)
            self.finish()
            return

        project_id = int(project_id)

        sentry_key = self.get_argument('sentry_key')
        if sentry_key.strip() != self.application.project_keys[project_id]["public_key"]:
            self.set_status(403)
            self.write("INVALID KEY")
            self.finish()
            return

        url = "%s/api/%d/store/?%s" % (self.application.config.SENTRY_BASE_URL, project_id, self.request.query)
        self.application.items_to_process.put(url)

        self.set_status(200)
        self.write("OK")
        self.finish()
