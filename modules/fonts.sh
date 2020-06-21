#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="fonts"
readonly module_log_file="${script_dir}/log/${module_name}.log"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if [[ ! -e "$HOME/Library/Fonts/UbuntuMono-R.ttf" ]]
then
  decho "installing ubuntu fonts..."
  cd /tmp || exit
  curl -s https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip -o fonts.zip >> "${module_log_file}" 2>&1
  unzip fonts.zip >> "${module_log_file}" 2>&1
  cd ubuntu-font-family-0.83 || exit
  cp ./*.ttf ~/Library/Fonts/
  cd .. || exit
  rm -rf ubuntu-font-family-0.83
else
  decho "ubuntu fonts already installed!"
fi
