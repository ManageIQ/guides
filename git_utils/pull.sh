#!/bin/bash

# Script for git updating git branch master topology inventory plugins
# Switches to master branch

current_branch=$(git rev-parse --abbrev-ref HEAD)

if git diff-index --quiet HEAD --; then
    git fetch --all --prune
    git checkout master
	
    has_upstream=`git branch -a | grep upstream | wc  -l`

    if [[ "$has_upstream" -gt "0" ]]; then
        git pull upstream master
    else
        git pull origin master
    fi
else
    echo "Changes in branch ${current_branch}, cannot apply GIT PULL"
    scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    ${scripts_dir}/list-changes.sh
fi
