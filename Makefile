ifneq ($(CYCLOPS_TEST_DB_USER),)
	DB_USER=-u $(CYCLOPS_TEST_DB_USER)
else
	DB_USER=-u root
endif

ifneq ($(CYCLOPS_TEST_DB_HOST),)
	DB_HOST=-h $(CYCLOPS_TEST_DB_HOST)
else
	DB_HOST=-h localhost
endif

ifneq ($(CYCLOPS_TEST_DB_PASS),)
	DB_PASS=-p$(CYCLOPS_TEST_DB_PASS)
else
	DB_PASS=
endif

test: redis db
	@nosetests -vv --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

ci-test: redis db
	@nosetests -vv --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

db:
	mysql $(DB_HOST) $(DB_USER) $(DB_PASS) -e "DROP DATABASE IF EXISTS sentry_tests"
	mysql $(DB_HOST) $(DB_USER) $(DB_PASS) -e "CREATE DATABASE IF NOT EXISTS sentry_tests"
	mysql $(DB_HOST) $(DB_USER) $(DB_PASS) sentry_tests < tests/sentry_db.sql

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
