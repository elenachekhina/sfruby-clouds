# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.4
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1" \
    DATA_PATH="/data"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems and node modules
RUN --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/var/cache/apt,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/var/lib/apt,target=/var/lib/apt,sharing=locked \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git curl pkg-config libyaml-dev

# Install application gems
COPY --link .ruby-version Gemfile Gemfile.lock ./
COPY --link gemfiles/rubocop.gemfile gemfiles/

RUN --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/srv/vendor,target=/srv/vendor,sharing=locked \
    bundle config set app_config .bundle && \
    bundle config set path /srv/vendor && \
    bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    bundle clean && \
    mkdir -p vendor && \
    bundle config set path vendor && \
    cp -ar /srv/vendor .

# Install NPM modules
COPY --link package.json bun.lock ./
COPY --link bin/bun bin/bun
RUN --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/root/.npm,target=/root/.npm,sharing=locked \
    bin/bun install

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 \
    ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/var/cache/apt,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=s/5664cc3e-976e-4d50-8d6b-d65cf44c8ccc-/var/lib/apt,target=/var/lib/apt,sharing=locked \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libyaml-0-2

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir /data && \
    chown -R 1000:1000 /rails /data
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
