#!/bin/sh

set -e

cd /app
npm install && NODE_OPTIONS='--inspect' node_modules/.bin/next dev -H users.jdw.local
#npm install && node_modules/.bin/next build && node_modules/.bin/next start -H users.jdw.local
