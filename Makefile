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
