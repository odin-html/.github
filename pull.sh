#!/bin/sh
# Pull the two odin-html repositories checked out beside this file.
cd "$(dirname "$0")"

for repo in odin-html-builder odin-html-ui; do
  echo "=== $repo ==="
  git -C "$repo" pull
done
