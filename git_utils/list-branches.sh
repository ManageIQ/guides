#!/bin/bash
# List of current branches in MiQ repositories

source config.sh

cd ${manageiq_root}

for path in ${repositories[@]}
do
	cd ${path}
	    current_branches=$(git branch)
		echo ""
		echo $(basename ${path})
		echo "${current_branches}"
	cd ..
done

