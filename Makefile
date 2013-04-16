test: redis
	@nosetests -vv --pdb --pdb-failures --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

ci-test: redis
	@nosetests -vv --with-yanc -s --with-coverage --cover-erase --cover-inclusive --cover-package=cyclops tests/

run:
	@python cyclops/server.py -vv

run-prod:
	@python cyclops/server.py

setup:
	@pip install -r requirements.txt

kill_redis:
	-redis-cli -p 7780 shutdown

redis: kill_redis
	redis-server ./redis.conf; sleep 1
	redis-cli -p 7780 info
