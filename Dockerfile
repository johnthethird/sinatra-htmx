FROM ruby:2.7.1-alpine AS builder

# Packages necessary to build native gems like puma, nokogiri, etc
ARG PACKAGES="build-base curl-dev git"

RUN apk add --update --no-cache ${PACKAGES} 

WORKDIR /home/app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 5 \
  # Remove unneeded files (cached *.gem, *.o, *.c)
  && find /usr/local/bundle/cache/ -name "*.gem" -delete \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

######################################################
FROM ruby:2.7.1-alpine

# Packages necessary to run the app
ARG PACKAGES="ca-certificates tzdata"

RUN apk add --update --no-cache ${PACKAGES} 

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Create a dedicated user for running the application
RUN adduser -D app
USER app
WORKDIR /home/app

COPY --chown=app . ./

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
