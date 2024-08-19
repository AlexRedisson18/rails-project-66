setup: install db-prepare copy-env

install:
	bundle install

db-prepare:
	bin/rails db:reset

copy-env:
	cp -n .env.example .env

start:
	rm -rf tmp/pids/server.pid
	bin/rails s

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/

test:
	bin/rails test

.PHONY: test
