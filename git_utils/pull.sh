#!/bin/bash

# Script for git updating git branch master topology inventory plugins
# Switches to master branches
source config.sh

cd ${manageiq_root}

modified_repos=()

for path in ${repositories[@]} 
do
	repo=$(basename ${path})

	echo "${repo} -------------------------------------------------------"
	cd ${path}
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
		echo "Changes in branch ${current_branch}"
		modified_repos+=(${repo})
	fi
	
	cd ..
done

echo ""
echo "Repositories with changes (cannot apply git pull):"
for repo in ${modified_repos[@]}
do
	echo ${repo}
done

