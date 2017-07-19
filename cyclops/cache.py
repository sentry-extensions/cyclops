#!/usr/bin/python
# -*- coding: utf-8 -*-

import redis


class Cache(object):
    def __init__(self, application):
        self.application = application

    def get(self, key):
        return None

    def set(self, key, expiration):
        pass


class NoCache(Cache):
    pass


class RedisCache(Cache):
    def __init__(self, application):
        super(RedisCache, self).__init__(application)

        if self.application.config.REDIS_HOST is not None:
            self.redis = redis.StrictRedis(
                host=self.application.config.REDIS_HOST,
                port=self.application.config.REDIS_PORT,
                db=self.application.config.REDIS_DB_COUNT,
                password=self.application.config.REDIS_PASSWORD
            )

    def get(self, key):
        value = self.redis.get(key)
        if value is None:
            return None

        return int(value)

    def incr(self, key):
        return self.redis.incr(key)

    def set(self, key, expiration):
        self.lock = self.redis.lock('cyclops:lock:%s' % key, timeout=5*60)
        if not self.lock.acquire(blocking=False):
            return

        try:
            self.redis.setex(
                key,
                expiration,
                0
            )
        finally:
            self.lock.release()

    def flushdb(self):
        self.redis.flushdb()
