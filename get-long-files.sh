#!/bin/bash

find all_repos/ -type f | \
  grep -v "\.git" | \
  xargs wc -l | \
  sort -h
