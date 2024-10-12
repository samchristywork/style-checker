#!/bin/bash

last_commit_after="2023-04-01"
last_commit_before="2024-01-26"

for x in ./all_repos/*; do
  (
    cd $x
    test -z "$last_commit_before" || \
    test -z "$(git log --since="$last_commit_before")" || {
      exit
    }

    test -z "$last_commit_after" || \
    test -z "$(git log --until="$last_commit_after")" || {
      exit
    }

    printf "$x "
    git log --date=short --pretty=format:"%ad" | head -n1
  )
done
