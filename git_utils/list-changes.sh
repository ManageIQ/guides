#!/usr/bin/env bash

# Script for list your changes in all repos
#
# NOTE: Edit your variables below!
source config.sh

cd ${manageiq_root}

empty_line=1

for path in ${repositories[@]}
do
	cd ${path}
	repo=$(basename ${path})
	current_branch=$(git rev-parse --abbrev-ref HEAD)

	if git diff-index --quiet HEAD --; then
		echo "${repo}:    No Changes (${current_branch})"
		empty_line=0
   	else
   	    if [[ ${empty_line} -eq 0 ]]; then
   	        echo ""
   	    fi
	    echo "<$repo> -------------------------------------------------------"
		git status -s -b
		echo "</$repo> ------------------------------------------------------"
		echo ""
		empty_line=1
	fi

	cd ..
done
