#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="spicetify"
readonly module_log_file="${script_dir}/log/${module_name}.log"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists spicetify
then
  # run spicetify to generate basic config
  spicetify

  # enable customisation
  spicetify backup apply enable-devtool

  # install themes
  themes_dir="$HOME/spicetify_data/Themes"

  mkdir -p "${themes_dir}"

  cd /tmp || exit

  if [[ -d "/tmp/spicetify-themes" ]]
  then
    rm -rf "/tmp/spicetify-themes"
  fi

  git clone https://github.com/morpheusthewhite/spicetify-themes.git
  cp -r "/tmp/spicetify-themes/Bittersweet" "${themes_dir}/"

  #cd /tmp && rm -rf /tmp/spicetify-themes || exit

  spicetify config current_theme Bittersweet
  spicetify apply
fi
