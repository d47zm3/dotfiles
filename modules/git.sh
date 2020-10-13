#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="git"
readonly module_log_file="${script_dir}/log/${module_name}.log"

config_files=( ".gitignore" ".gitconfig" )
config_source_dir="${script_dir}/git"
config_destination_dir="${HOME}"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists git
then
  cd "${script_dir}" || exit
  decho "remember to add your private ssh key!"

  for config in "${config_files[@]}"
  do
    if [[ -e "${config_destination_dir}/${config}" ]]
    then
      if ! cmp --silent "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
      then
        decho "source config ${config} and existing one differs, installing source one and backing up current one..."
        cp "${config_destination_dir}/${config}" "${config_destination_dir}/${config}.$( date +%s )"
        rm -f "${config_destination_dir}/${config}"
        ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
      fi
      link_target=$( greadlink -f "${config_destination_dir}/${config}" )
      if [[ "${link_target}" != "${config_source_dir}/${config}" ]]
      then
        decho "existing link ${link_target} does not match current source one ${config_source_dir}/${config}, replacing..."
        rm -f "${config_destination_dir}/${config}"
        ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
      fi
    else
      ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
    fi
  done
else
  decho "skipping ${module_name} setup... binary not found"
fi
