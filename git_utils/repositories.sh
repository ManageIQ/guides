#!/usr/bin/env bash

if [[ ${custom_repo_list} -eq 0 ]]; then
    repositories=("${manageiq_root}")
    idx=1
    for dir in ${manageiq_root}/${plugins_dir}/*
    do
        if [[ -d ${dir} ]]; then
            repositories[${idx}]=${dir}
            idx=$((idx+1))
        fi
    done
fi
