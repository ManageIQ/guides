#!/bin/bash

# Script for git updating master git branch an rebase current working branch

source config.sh

cd ${manageiq_root}

modified_repos=()

for path in ${repositories[@]} 
do
	echo "${repo} -------------------------------------------------------"
	cd ${path}
	current_branch=$(git rev-parse --abbrev-ref HEAD)


	if git diff-index --quiet HEAD --; then
		echo "* Updating (rebase) branch ${current_branch}"
		git fetch --all --prune
		git checkout master
	
		has_upstream=`git branch -a | grep upstream | wc  -l`

		if [[ "$has_upstream" -gt "0" ]]; then
			git pull upstream master
		else
			git pull origin master
		fi

		if [[ ${current_branch} -ne "master" ]]; then
			git checkout ${current_branch}
			git rebase master
		fi
	else
		echo "Cannot update branch ${current_branch}: Modified files present"
		modified_repos+=(${repo})
	fi
	
	cd ..
done

echo ""
echo "Repositories with changes (cannot apply git rebase):"
for repo in ${modified_repos[@]}
do
	echo ${repo}
done

