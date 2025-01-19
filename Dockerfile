# syntax=docker/dockerfile:1

# Set the Ruby version to use
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim AS base

# Set the working directory inside the container
WORKDIR /rails

# Install system dependencies required for Rails and the app
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 postgresql-client libpq-dev \
    build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Set environment variables for production build
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Build stage: Install dependencies and precompile assets
FROM base AS build

# Copy Gemfile and Gemfile.lock to install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application source files and precompile additional assets
COPY . .
RUN bundle exec bootsnap precompile app/ lib/

# Runtime image: Copy the installed gems and application from the build stage
FROM base

# Copy the installed gems and the full application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Create user and set file ownership for Rails
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

# Install sudo (for fixing permission issues if needed)
RUN apt-get update && apt-get install -y sudo

# Ensure entrypoint script is executable
COPY docker-entrypoint.sh /rails/bin/
RUN sudo chmod +x /rails/bin/docker-entrypoint.sh && \
    sudo chown rails:rails /rails/bin/docker-entrypoint.sh

# Switch to the rails user for security
USER rails

# Expose the Rails server port (3000) to allow traffic from outside
EXPOSE 3000

# Set the entrypoint to your script and start Rails
ENTRYPOINT ["/rails/bin/docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
