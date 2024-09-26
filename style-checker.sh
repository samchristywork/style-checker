#!/bin/bash

last_commit_after="2024-02-01"
last_commit_before="2024-05-01"

cd all_repos

function test_files() {
  while test "$#" -gt "0"; do
    test -e "$1" || echo "$1"
    shift
  done
}

function test_file_contains_string() {
  # Return if the file doesn't exist
  test -e "$1" || return 0

  grep -qs "$2" "$1"
  return $?
}

function test_file_length() {
  git ls-files | grep "$1$" | while read file; do
    test -f "$file" && test "$(wc -l < "$file")" -gt "$2" && echo "$file"
  done
}

(
for repo in *; do
  (
    cd "$repo"

    test -z "$last_commit_before" || \
    test -z "$(git log --since="$last_commit_before")" || {
      #echo "Skipping $repo" > /dev/stderr
      exit
    }

    test -z "$last_commit_after" || \
    test -z "$(git log --until="$last_commit_after")" || {
      #echo "Skipping $repo" > /dev/stderr
      exit
    }

    # Get every line from errcheck that don't include defer
    test -e go.mod && ~/go/bin/errcheck . | grep -v defer | \
      sed 's/^/errcheck     |/g'

    # Find lines that are longer than 120 characters
    git grep -n -r ".\{120\}" | grep -v "go.sum\|svg\|codegen" | \
      sed 's/^/line length  |/g'

    # Test if the following files exist
    test_files README.md CONTRIBUTING.md LICENSE .gitignore | \
      sed 's/^/missing file |/g'

    # Make sure C-like projects have a src directory
    test -e Makefile && \
      (test -d src || echo Missing src directory in project with a Makefile) | \
      sed 's/^/missing src   |/g'

  ) | sed  's/^.............|/& '$repo':/g'
done | \
  tee /tmp/style-checker | \
  sed 's/\t/  /g' | \
  cut -c1-$(tput cols)

echo
wc -l < /tmp/style-checker | sed 's/$/ warnings/g' > /dev/stderr
echo "Output saved to /tmp/style-checker" > /dev/stderr
)
