#!/bin/bash

for x in ./all_repos/*; do
  (
    cd $x
    git log --date=short --pretty=format:"%ad" | sort
  )
done
