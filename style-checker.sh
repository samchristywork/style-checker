#!/bin/bash

cd ~/git/code-search/all_repos

(
for repo in *; do
  (
    cd "$repo"

    # Get every line from errcheck that don't include defer
    test -e go.mod && ~/go/bin/errcheck . | grep -v defer | \
      sed 's/^/e /g'

    # Find lines that are longer than 120 characters
    git grep -n -r ".\{120\}" | grep -v "go.sum\|svg" | \
      sed 's/^/l /g'

  ) | sed 's/^./& '$repo':/g'
done | tee /tmp/style-checker

wc -l < /tmp/style-checker | sed 's/$/ warnings/g' > /dev/stderr
echo "Output saved to /tmp/style-checker" > /dev/stderr
)
