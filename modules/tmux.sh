#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="tmux"
readonly module_log_file="${script_dir}/log/${module_name}.log"

config_files=( ".tmux.conf" )
config_source_dir="${script_dir}/tmux"
config_destination_dir="${HOME}"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists tmux
then
  cd "${script_dir}" || exit

  if [[ ! -d ~/.tmux/plugins/tpm ]]
  then
    decho "installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm  >> "${module_log_file}" 2>&1
  fi

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
    else
      ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
    fi
  done

  if [[ ! -d "$HOME/.tmux/plugins/tmux-online-status" ]]
  then
    decho "installing tmux plugins"
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" >> "${module_log_file}" 2>&1
  fi
else
  decho "skipping ${module_name} setup... binary not found"
fi
