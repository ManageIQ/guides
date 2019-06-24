#!/usr/bin/env bash

# You can override these values in file config.dev.sh
manageiq_root="${HOME}/Projects/ManageIQ/upstream"
plugins_dir="plugins"

if [[ -f "./config.dev.sh" ]]; then
    source "config.dev.sh"
fi

# $custom_repo_list:
# - when 0, then all repos in $manageiq_root and plugins are used
# - when 1, user-defined list ${repositories} is used.
#   Can be defined in config.dev.sh (see example below)
custom_repo_list=0
#repositories=("${manageiq_root}"
#              "${manageiq_root}/${plugins_dir}/manageiq-ui-classic"
#              "${manageiq_root}/${plugins_dir}/manageiq-api")

source repositories.sh
