#!/usr/bin/python
# -*- coding: utf-8 -*-

from derpconf.config import Config, generate_config

MINUTES = 60

Config.define('HEALTHCHECK_TEXT', 'WORKING', 'Cyclops has a /healthcheck route. This allows load balancers to ping it to see if the process is still alive. This option defines the text that the /healthcheck route prints.', 'General')
Config.define('SENTRY_BASE_URL', 'localhost:9000', 'Sentry server name. This is the base URL that Cyclops will use to send requests to sentry.', 'General')
Config.define('UPDATE_PERIOD', 2 * MINUTES, "Cyclops keeps sentry's projects public and security keys in memory. This allows a very fast validation as to whether each request is valid. This configuration defines the interval in seconds that Cyclops will update the keys.", 'General')
Config.define('PROCESS_NEWER_MESSAGES_FIRST', True, "This configuration tells cyclops to process newly arrived error reports first. This is very useful to avoid that error bursts stop you from seeing new errors.", 'General')

Config.define(
    'STORAGE',
    'cyclops.storage.InMemoryStorage',
    'The storage class used in Cyclops. Storage classes are what define how received requests will be treated *before* sending to sentry. ' +
    'Built-ins: "cyclops.storage.InMemoryStorage" and "cyclops.storage.RedisStorage."',
    'General'
)

Config.define('MAX_DUMP_INTERVAL', 1000, 'Cyclops will try to send the errors it receives to sentry as fast as possible. This is done using a percentile average of 90% of the last sentry requests time. If those requests were serviced in 30ms average, then cyclops will keep sending requests every 30ms. This setting specify a maximum interval in miliseconds to send requests to sentry.', 'Performance')
Config.define('MAX_REQUESTS_TO_AVERAGE', 5000, 'In order to calculate the average requests, Cyclops keeps track of the times of the last requests sent to sentry. This setting specifies the maximum number of requests to average.', 'Performance')
Config.define('IGNORE_PERCENTAGE', {}, 'Use this rate to ignore a percentage of requests if flooded. The keys for this dictionary are the project IDs and the value are the percentage of requests to ignore.', 'Performance')

Config.define('PROJECT_KEYS', None, 'List of (project_id, public_key, secret_key) tuples that describe the projects handled by this Cyclops instance.', 'Projects')
Config.define('MYSQL_HOST', 'localhost', 'Host of your sentry installation MySQL database. Set this to None if you do not wish to load project keys from the database. In that case, you will have to fill the PROJECT_KEYS variable.', 'Database')
Config.define('MYSQL_PORT', 3306, 'Port of your sentry installation MySQL database.', 'Database')
Config.define('MYSQL_DB', 'sentry', 'Database of your sentry installation MySQL database.', 'Database')
Config.define('MYSQL_USER', 'root', 'User of your sentry installation MySQL database.', 'Database')
Config.define('MYSQL_PASS', '', 'Password of your sentry installation MySQL database.', 'Database')

Config.define('URL_CACHE_EXPIRATION', 1, 'The amount of seconds to cache a given URL of error. This is meant to be a way to avoid flooding your sentry farm with repeated errors. Set to 0 if you don\'t want to cache any errors.', 'Cache')
Config.define('MAX_CACHE_USES', 10, 'Number of requests to accept in the specified expiration of the cache per url.', 'Cache')

Config.define('CACHE_IMPLEMENTATION_CLASS', 'cyclops.cache.RedisCache', 'The cache implementation to use to avoid sending the same error again to sentry.', 'Cache')
Config.define('REDIS_HOST', '127.0.0.1', 'The host where the Redis server is running. If you are not using redis, set this to None.', 'Cache')
Config.define('REDIS_PORT', 7780, 'The port that Redis server is running.', 'Cache')
Config.define('REDIS_DB_COUNT', 0, 'The number of redis db.', 'Cache')
Config.define('REDIS_PASSWORD', None, 'The redis password', 'Cache')

if __name__ == '__main__':
    generate_config()
