#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="tfenv"
readonly module_log_file="${script_dir}/log/${module_name}.log"

terraform_versions=( "0.13.6" )

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists tfenv
then
  for version in "${terraform_versions[@]}"
  do
    if ! tfenv list | grep -q "${version}"
    then
      tfenv install "${version}"
    fi
  done
else
  decho "skipping ${module_name} setup... binary not found"
fi
