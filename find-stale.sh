#!/bin/bash

for repo in ./all_repos/*; do
  (
    cd "$repo"
    test -z "$(git log --since="1 year ago")" && {
      echo "$repo"
    }
  )
done
