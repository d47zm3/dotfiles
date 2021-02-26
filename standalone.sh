#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

script_dir="${1}"
readonly module_name="standalone"
readonly module_log_file="${script_dir}/log/${module_name}.log"
decho "initialising ${module_name} module..."
true > "${module_log_file}"

vagrant_plugins=( "vagrant-vmware-desktop" "vagrant-disksize")
local_vmware_link="http://basement.d47zm3.me:8192/vmware-fusion.rb"

decho "checking sudo & allow all apps..."
if [ "$EUID" -eq 0 ]
then
  decho "[error] do not run as root/sudo!"
  exit 1
fi

sudo -v

# keep-alive: update existing `sudo` time stamp until setup has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo spctl --master-disable

# standalone module, vmware/vagrant

brew_apps=(
  "vagrant"
  "vagrant-vmware-utility"
)

# download and install older vmware-fusion, until there is license for new version
curl -O vmware-fusion.rb "${local_vmware_link}"
brew install --cask ./vmware-fusion.rb
rm -f vmware-fusion.rb

decho "installing stadalone brew --cask utils..."
if ! brew --cask install "${brew_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] brew --cask install returned an error!"
fi

for vagrant_plugin in "${vagrant_plugins[@]}"
do
  if ! vagrant plugin list | grep -q "${vagrant_plugin}"
  then
    decho "installing plugin ${vagrant_plugin} for vagrant..."
      if ! vagrant plugin install "${vagrant_plugin}" >> "${module_log_file}" 2>&1
      then
      decho "[error] vagrant plugin install ${vagrant_plugin} returned an error!"
    fi
  fi
done

decho "installing license for vagrant: $ vagrant plugin license vagrant-vmware-desktop <license file>"

decho "cleanup..."
brew cleanup &> /dev/null
sudo spctl --master-enable

decho "finished!"
