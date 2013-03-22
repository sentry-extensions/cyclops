run:
	@python cyclops/server.py -vvv

run-prod:
	@python cyclops/server.py

setup:
	@pip install -r requirements.txt
