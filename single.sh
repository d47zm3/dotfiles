#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

decho "starting macos setup (single module)..."

module_name="${1:-"default"}"

if [[ ${module_name} ==  "default" ]]
then
  all_modules=( ./modules/*.sh )
  #all_modules=( "$( ls ./modules/*.sh | grep -v -E "brew.sh|miscellaneous.sh" | tr '\n' '\0' | xargs -0 -n 1 basename )" )
  decho "single module mode, required as an argument!"
  decho "${0} <module name>"
  decho "available modules:"
  for module in "${all_modules[@]}"
  do
    if [[ ${module} != "./modules/brew.sh" ]] && [[ ${module} != "./modules/miscellaneous.sh" ]]
    then
      echo "[***] $( basename ${module} | sed -e 's/\.sh//g' )"
    fi
  done
  exit 1
fi

mkdir -p "${script_dir}/log"

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

"modules/${module_name}.sh" "${script_dir}"

decho "cleanup..."
brew cleanup &> /dev/null
sudo spctl --master-enable

decho "finished!"
