#!/bin/bash
set -e

# Wait for the database to be ready (optional, depending on your setup)
echo "Waiting for database to be ready..."
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 1
done
echo "Database is ready!"

# Run any pending migrations
echo "Running database migrations..."
bundle exec rake db:migrate

# Precompile assets (optional, but recommended for production)
echo "Precompiling assets..."
bundle exec rake assets:precompile

# Start the Rails server
echo "Starting Rails server..."
exec "$@"
