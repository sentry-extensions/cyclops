run:
	@python cyclops/server.py -vv

run-prod:
	@python cyclops/server.py

setup:
	@pip install -r requirements.txt
