#!/usr/bin/python
# -*- coding: utf-8 -*-

from Queue import Queue, LifoQueue, Empty
from collections import defaultdict
import random

import msgpack
import redis


class InMemoryStorage(object):
    def __init__(self, application):
        self.application = application

        if self.application.config.PROCESS_NEWER_MESSAGES_FIRST:
            self.items_to_process = defaultdict(LifoQueue)
        else:
            self.items_to_process = defaultdict(Queue)

    def put(self, project_id, message):
        self.items_to_process[project_id].put(msgpack.packb(message))

    def get_size(self, project_id):
        return self.items_to_process[project_id].qsize()

    def get_next_message(self):
        projects = self.items_to_process.keys()
        if not projects:
            return None

        try:
            msg = self.items_to_process[random.choice(projects)].get_nowait()
        except Empty:
            return None

        return msgpack.unpackb(msg)

    def mark_as_done(self, project_id):
        self.items_to_process[project_id].task_done()

    @property
    def total_size(self):
        return sum([q.qsize() for q in self.items_to_process.values()])

    @property
    def available_queues(self):
        return [str(project_id) for project_id in self.items_to_process.keys()]


class RedisStorage(object):
    def __init__(self, application):
        self.application = application

        if self.application.config.REDIS_HOST is None:
            raise RuntimeError(
                "If you are using RedisStorage you need to set in your configuration file the " +
                "following keys: REDIS_HOST, REDIS_PORT, REDIS_DB_COUNT and REDIS_PASSWORD(optional)"
            )

        self.redis = redis.StrictRedis(
            host=self.application.config.REDIS_HOST,
            port=self.application.config.REDIS_PORT,
            db=self.application.config.REDIS_DB_COUNT,
            password=self.application.config.REDIS_PASSWORD
        )

    @property
    def projects_key(self):
        return "cyclops:projects"

    def get_queue_key(self, project_id):
        return "cyclops:queue:%s" % project_id

    def clear(self):
        for project_id in self.get_projects():
            self.redis.delete(self.get_queue_key(project_id))
        self.redis.delete(self.projects_key)

    def get_projects(self):
        projects = self.redis.smembers(self.projects_key)
        if not projects:
            return []

        return projects

    def put(self, project_id, message):
        self.redis.sadd(self.projects_key, project_id)
        self.redis.rpush(self.get_queue_key(project_id), msgpack.packb(message))

    def get_size(self, project_id):
        key = self.get_queue_key(project_id)
        return self.redis.llen(key)

    def get_next_message(self):
        projects = list(self.redis.smembers(self.projects_key))
        if not projects:
            return None

        project_id = random.choice(projects)
        msg = self.redis.rpop(self.get_queue_key(project_id))
        if not msg:
            return None

        return msgpack.unpackb(msg)

    def mark_as_done(self, project_id):
        pass  # no need to do anything in Redis

    @property
    def total_size(self):
        return sum([self.redis.llen(self.get_queue_key(project_id)) for project_id in self.get_projects()])

    @property
    def available_queues(self):
        return [str(project_id) for project_id in self.get_projects()]
