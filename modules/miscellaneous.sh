#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="miscellaneous"
readonly module_log_file="${script_dir}/log/${module_name}.log"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/id_rsa"
chmod 600 "$HOME/.ssh/id_rsa"
mkdir -p "$HOME/Projects/{Personal,Work}"

vagrant plugin install vagrant-vmware-desktop
decho "install license for vagrant: $ vagrant plugin license vagrant-vmware-desktop <license file>"
