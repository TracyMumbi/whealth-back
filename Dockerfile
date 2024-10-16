# Use specific version of Dockerfile syntax
# Adjust RUBY_VERSION to match your project's .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set working directory for Rails app
WORKDIR /rails

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Install packages needed for build stage
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config \
    libpq-dev  # Install libpq-dev for PostgreSQL gem (pg) compilation

# Stage for building the application
FROM base as build

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs "$(nproc)" --retry 5

# Remove unnecessary files to reduce image size
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets for production (dummy SECRET_KEY_BASE for asset precompilation)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final stage for minimal runtime image
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libsqlite3-0 \
    libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy built artifacts from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create a non-root user for running the application
RUN useradd -m -d /rails rails && chown -R rails:rails /rails
USER rails

# Entrypoint script to prepare the database and handle other setup tasks
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port 3000 and start Rails server by default
EXPOSE 3000
CMD ["./bin/rails", "server"]
