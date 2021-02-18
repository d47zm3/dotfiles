#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="pyenv"
readonly module_log_file="${script_dir}/log/${module_name}.log"

python_versions=( "3.8.7" )
default_version=( "3.8.7" )

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists pyenv
then

  for version in "${python_versions[@]}"
  do
    if ! pyenv versions | grep -q "${version}" >> "${module_log_file}" 2>&1
    then
      pyenv install "${version}" >> "${module_log_file}" 2>&1
    fi
  done
  pyenv global "${default_version}"
else
  decho "skipping ${module_name} setup... binary not found"
fi
