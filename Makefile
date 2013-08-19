test: redis db
	@nosetests -vv --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

ci-test: redis db
	@nosetests -vv --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

db:
	@mysql -u root -e "DROP DATABASE IF EXISTS sentry_tests"
	@mysql -u root -e "CREATE DATABASE IF NOT EXISTS sentry_tests"
	@mysql -u root sentry_tests < tests/sentry_db.sql

run:
	@python cyclops/server.py -vv

run-prod:
	@python cyclops/server.py

setup:
	@pip install -e .\[tests\]

kill_redis:
	-redis-cli -p 7780 shutdown

redis: kill_redis
	redis-server ./redis.conf; sleep 1
	redis-cli -p 7780 info
