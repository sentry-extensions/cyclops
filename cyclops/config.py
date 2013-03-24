#!/usr/bin/python
# -*- coding: utf-8 -*-

from derpconf.config import Config, generate_config

MINUTES = 60

Config.define('HEALTHCHECK_TEXT', 'WORKING', 'Healthcheck text.', 'General')
Config.define('SENTRY_BASE_URL', 'http://localhost:9000', 'Sentry base url to access the API with.', 'General')
Config.define('UPDATE_PERIOD', 2 * MINUTES, 'Time in seconds to update the project public and private keys.', 'General')
Config.define('MAX_DUMP_INTERVAL', 1000, 'Maximum Time in miliseconds to send a request to sentry.', 'General')
Config.define('MAX_REQUESTS_TO_AVERAGE', 5000, 'Maximum number of requests to average.', 'General')


Config.define('MYSQL_HOST', 'localhost', 'MySQL host.', 'Database')
Config.define('MYSQL_PORT', 3306, 'MySQL host.', 'Database')
Config.define('MYSQL_DB', 'sentry', 'MySQL database.', 'Database')
Config.define('MYSQL_USER', 'root', 'MySQL user.', 'Database')
Config.define('MYSQL_PASS', '', 'MySQL pass.', 'Database')

Config.define('REDIS_HOST', '127.0.0.1', 'The host where the Redis server is running.', 'Cache')
Config.define('REDIS_PORT', 7778, 'The port that Redis server is running.', 'Cache')
Config.define('REDIS_DB_COUNT', 0, 'The number of redis db.', 'Cache')
Config.define('REDIS_PASSWORD', '', 'The redis password', 'Cache')

if __name__ == '__main__':
    generate_config()
