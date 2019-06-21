#!/bin/bash
# Script for git cleanup - delete merged branches
# Switches to master branches
#
# Usage: cleanup.sh [--remote-cleanup]

source config.sh

case $1 in
    -f|--remote-cleanup) remote_cleanup=1;;
esac

cd ${manageiq_root}

for path in ${repositories[@]}
do
    repo=$(basename ${path})
	echo "${repo} -------------------------------------------------------"
	cd ${path}

    # This has to be run from master
    git checkout master

    # Update our list of remotes
    git fetch
    git remote prune origin

    # Remove local fully merged branches
    local_merged=$(git branch --merged master | grep -v 'master$')
    if [[ -z ${local_merged} ]]; then
        echo "No local branches to delete"
    else
        echo ${local_merged} | xargs git branch -d
    fi


    has_upstream=`git branch -a | grep upstream | wc  -l`

    if [[ ${remote_cleanup} -eq 1 && "$has_upstream" -gt "0" ]]
    then
        remote_merged=$(git branch -r --merged master | sed 's/ *origin\///' | grep -v 'master$')
        if [[ -z ${remote_merged} ]]; then
           echo "No remote branches to delete"
        else
            # Remove remote fully merged branches
            echo ${remote_merged} | xargs -I% git push origin :%
        fi
    fi
	cd ..
done
