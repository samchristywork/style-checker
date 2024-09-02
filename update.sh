#!/bin/bash

mkdir -p all_repos
cd all_repos

gh api users/samchristywork/repos --paginate  --jq '.[] | "\(.name)"' | \
  while read repo; do
    test -d "$repo" || git clone "git@github.com:samchristywork/$repo.git"

    (
      cd "$repo"
      git pull
    )
  done
