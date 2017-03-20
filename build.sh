#!/bin/bash

touch yarn.lock

if [[ -z "${CIRCLE_BRANCH}" ]]; then
  # running in non ci environment
  RM="--rm"
else
  # running on circle ci
  RM="--rm=false"
fi

# Init empty cache file
if [ ! -f .yarn-cache.tgz ]; then
  echo "Init empty .yarn-cache.tgz"
  tar cvzf .yarn-cache.tgz --files-from /dev/null
fi

echo docker build $RM -t yarn-demo .
docker build $RM -t yarn-demo .

echo docker run $RM --entrypoint cat yarn-demo:latest /tmp/yarn.lock > /tmp/yarn.lock
docker run $RM --entrypoint cat yarn-demo:latest /tmp/yarn.lock > /tmp/yarn.lock

if ! diff -q yarn.lock /tmp/yarn.lock > /dev/null  2>&1; then
  echo "Saving Yarn cache"

  echo docker run $RM --entrypoint tar yarn-demo:latest czf - /root/.yarn-cache/ > .yarn-cache.tgz
  docker run $RM --entrypoint tar yarn-demo:latest czf - /root/.yarn-cache/ > .yarn-cache.tgz

  echo "Saving yarn.lock"
  cp /tmp/yarn.lock yarn.lock
fi
