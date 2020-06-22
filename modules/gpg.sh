#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="gpg"
readonly module_log_file="${script_dir}/log/${module_name}.log"

config_files=( "gpg.conf" )
config_source_dir="${script_dir}/gpg"
config_destination_dir="${HOME}/.gnupg"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists gpg
then

  cd "${script_dir}" || exit
  gpg --list-keys  >> "${module_log_file}" 2>&1
  echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  curl -s https://keybase.io/d47zm3/pgp_keys.asc | gpg --import >> "${module_log_file}" 2>&1
  gpg --list-secret-keys --keyid-format LONG >> "${module_log_file}" 2>&1
  decho "remember to add your private gpg key!"

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
  chown -R d47zm3:staff "${config_destination_dir}"
else
  decho "skipping ${module_name} setup... binary not found"
fi
