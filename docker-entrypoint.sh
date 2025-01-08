#!/bin/bash
set -e

# Any setup commands or environment variable initialization can go here.
# For example, if you need to initialize a database, you could add a command like:
# rake db:create db:migrate

# Start your application (e.g., Rails server or another app)
exec "$@"
