#!/bin/sh

set -e

export ENT_NATIVE_KEY="$(cat /run/secrets/ionic_ent_key)"

cd /app
npm install && NODE_OPTIONS='--inspect' node_modules/.bin/ionic serve --host=${HOSTNAME} --port=${PORT}
