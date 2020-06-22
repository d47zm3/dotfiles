#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

decho "starting macos setup..."

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

# brew module has to be executed first
"modules/brew.sh" "${script_dir}"

# follow with the rest
for module in $( ls ./modules/*.sh | grep -v "brew.sh" )
do
  "${module}" "${script_dir}"
done

decho "cleanup..."
brew cleanup &> /dev/null
sudo spctl --master-enable

decho "finished!"
