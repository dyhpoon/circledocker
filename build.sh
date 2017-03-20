#!/bin/bash

touch yarn.lock

# Init empty cache file
if [ ! -f .yarn-cache.tgz ]; then
  echo "Init empty .yarn-cache.tgz"
  tar cvzf .yarn-cache.tgz --files-from /dev/null
fi

if [[ -z "${CIRCLE_BRANCH}" ]]; then
  # running in non ci environment
  echo 'docker build -t yarn-demo .'
  docker build -t yarn-demo .
else
  # running on circle ci
  echo 'docker build --rm=false -t yarn-demo .'
  docker build --rm=false -t yarn-demo .
fi

docker run --rm --entrypoint cat yarn-demo:latest /tmp/yarn.lock > /tmp/yarn.lock
if ! diff -q yarn.lock /tmp/yarn.lock > /dev/null  2>&1; then
  echo "Saving Yarn cache"
  docker run --rm --entrypoint tar yarn-demo:latest czf - /root/.yarn-cache/ > .yarn-cache.tgz
  echo "Saving yarn.lock"
  cp /tmp/yarn.lock yarn.lock
fi
