#!/usr/bin/env bash

source config.sh

scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for path in ${repositories[@]}
do
    repo=$(basename ${path})
    echo "${repo} -------------------------------------------------------"
    cd ${path}

    ${scripts_dir}/$1.sh $2
done
