#!/bin/sh
# Push the two odin-html repositories checked out beside this file.
cd "$(dirname "$0")"

# Push only when HEAD has commits its upstream lacks, as last fetched; with no
# upstream, push anyway so git reports the error.
push() {
  if [ "$(git -C "$1" rev-list --count @{u}..HEAD 2>/dev/null || echo 1)" = 0 ]; then
    echo "up to date (local)"
  else
    git -C "$1" push
  fi
}

for repo in odin-html-builder odin-html-ui; do
  echo "=== $repo ==="
  push "$repo"
done
