#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="mas"
readonly module_log_file="${script_dir}/log/${module_name}.log"

mas_apps=(
  "1475387142"
  )

decho "initialising ${module_name} module..."

mkdir -p "${script_dir}/log"
true > "${module_log_file}"
fi

decho "installing mas utils..."
if ! mas install "${mas_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] mas install returned an error!"
fi
