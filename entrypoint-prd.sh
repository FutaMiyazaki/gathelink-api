#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

#下記行は2回目以降のデプロイ時にコメントアウトする
#rails db:create RAILS_ENV=production

rails db:migrate RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
