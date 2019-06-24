#!/usr/bin/env bash

# Script for list your GIT changes

current_branch=$(git rev-parse --abbrev-ref HEAD)

if git diff-index --quiet HEAD --; then
    echo "No Changes (${current_branch})"
else
    git status -s -b
fi
