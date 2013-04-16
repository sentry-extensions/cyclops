#!/usr/bin/python
# -*- coding: utf-8 -*-

from Queue import Queue, LifoQueue, Empty
from collections import defaultdict
import random

import msgpack


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


#class RedisCache(Cache):
    #def __init__(self, application):
        #super(RedisCache, self).__init__(application)

        #if self.application.config.REDIS_HOST is not None:
            #self.redis = redis.StrictRedis(
                #host=self.application.config.REDIS_HOST,
                #port=self.application.config.REDIS_PORT,
                #db=self.application.config.REDIS_DB_COUNT,
                #password=self.application.config.REDIS_PASSWORD
            #)

    #def get(self, key):
        #value = self.redis.get(key)
        #if value is None:
            #return None

        #return int(value)

    #def incr(self, key):
        #return self.redis.incr(key)

    #def set(self, key, expiration):
        #self.lock = RedisLock(self.redis, lock_key='cyclops:lock:%s' % key, lock_timeout=5*60)
        #if not self.lock.acquire():
            #return

        #try:
            #self.redis.setex(
                #key,
                #expiration,
                #0
            #)
        #finally:
            #self.lock.release()
