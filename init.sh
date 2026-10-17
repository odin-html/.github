#!/bin/sh
# Initialize the odin-html checkout root: clone the two repositories as
# sibling directories of this file, skipping any already checked out.
set -e
cd "$(dirname "$0")"

for repo in odin-html-builder odin-html-ui; do
  if [ -d "$repo" ]; then
    echo "=== $repo === already exists, skipping"
  else
    echo "=== $repo ==="
    git clone "git@github.com:odin-html/$repo.git"
  fi
done
