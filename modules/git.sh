#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="git"
readonly module_log_file="${script_dir}/log/${module_name}.log"

config_files=( ".gitignore" )
config_source_dir="${script_dir}/git"
config_destination_dir="${HOME}"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists git
then
  cd "${script_dir}" || exit

# shellcheck disable=SC2129
  git config --global user.name "Damian Tykalowski" >> "${module_log_file}" 2>&1
  git config --global user.email d47zm3@gmail.com >> "${module_log_file}" 2>&1
  git config --global core.editor vim >> "${module_log_file}" 2>&1
  git config --global user.signingkey DD1D600D4228ED66 >> "${module_log_file}" 2>&1
  git config --global commit.gpgsign true >> "${module_log_file}" 2>&1
  git config --global tag.forceSignAnnotated true >> "${module_log_file}" 2>&1
  git config --global core.excludesfile ~/.gitignore
  git config --list >> "${module_log_file}" 2>&1
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
      else
        decho "${config} already installed..."
      fi
    else
      ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
    fi
  done
else
  decho "skipping ${module_name} setup... binary not found"
fi
