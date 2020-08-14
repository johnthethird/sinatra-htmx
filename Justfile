# Justfile, a sane Make-like command runner
dev: bundle
	bundle exec rackup --host 0.0.0.0 -p 4567

bundle:
  bundle install

build:
	docker build -t sinatrahtmx . 

run: build
	docker run --init -i --rm -p "4567:4567" sinatrahtmx
