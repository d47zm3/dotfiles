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
mkdir -p "$HOME/Projects/Personal"
mkdir -p "$HOME/Projects/Work"

config_files=( ".rgignore" ".pylintrc")
config_source_dir="${script_dir}/miscellaneous"
config_destination_dir="${HOME}"

cd "${script_dir}" || exit
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
    link_target=$( greadlink -f "${config_destination_dir}/${config}" )
    if [[ "${link_target}" != "${config_source_dir}/${config}" ]]
    then
      decho "existing link ${link_target} does not match current source one ${config_source_dir}/${config}, replacing..."
      rm -f "${config_destination_dir}/${config}"
      ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
    fi
  else
    ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
  fi
done

# disable error check cause of grep
set +e
decho "mark chromedriver as safe"
cwd_dir=$(pwd)
src_dir=$(dirname $( which chromedriver))

cd "${src_dir}" || decho "chromedriver not found!"
xattr -p chromedriver | grep -i -q com.apple.quarantine
if [[ ${?} -eq 0 ]]
then
  decho "remove quarantine attribute on chromedriver..."
  xattr -d com.apple.quarantine chromedriver
fi
set -e

cd "${cwd_dir}" || exit 1

decho "install krew, kubectl addon"
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
) >> "${module_log_file}" 2>&1
decho "install krew plugins"
kubectl krew install advise-psp kubesec-scan >> "${module_log_file}" 2>&1

decho "removing unnecessary icons..."
# shellcheck disable=SC2129
dockutil --remove "Launchpad" >> "${module_log_file}" 2>&1
dockutil --remove "Calendar" >> "${module_log_file}" 2>&1
dockutil --remove "TV" >> "${module_log_file}" 2>&1
dockutil --remove "Podcasts" >> "${module_log_file}" 2>&1
dockutil --remove "App Store" >> "${module_log_file}" 2>&1
dockutil --remove "Music" >> "${module_log_file}" 2>&1
dockutil --remove "Reminders" >> "${module_log_file}" 2>&1
dockutil --remove "Photos" >> "${module_log_file}" 2>&1
dockutil --remove "Maps" >> "${module_log_file}" 2>&1
dockutil --remove "FaceTime" >> "${module_log_file}" 2>&1
dockutil --remove "Messages" >> "${module_log_file}" 2>&1
dockutil --remove "Contacts" >> "${module_log_file}" 2>&1
dockutil --remove "Notes" >> "${module_log_file}" 2>&1
dockutil --remove "Mail" >> "${module_log_file}" 2>&1
dockutil --remove "Downloads" >> "${module_log_file}" 2>&1
dockutil --remove "System Preferences" >> "${module_log_file}" 2>&1
dockutil --remove "Safari" >> "${module_log_file}" 2>&1

decho "installing iterm profile..."
if [[ -e "$HOME/Library/Application\ Support/iTerm2/DynamicProfiles/" ]]
then
  rm -f "$HOME/Library/Application\ Support/iTerm2/DynamicProfiles/"
fi

mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"
cp "${script_dir}/${module_name}/Profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"

decho "starting syncthing service..."
brew services start syncthing >> "${module_log_file}" 2>&1

decho "installing helm plugins..."
set +e
helm plugin install https://github.com/databus23/helm-diff >> "${module_log_file}" 2>&1
set -e

# something weird happeninng...
# decho "tweaking macos settings..."
#"${script_dir}/${module_name}/macosx" >> "${module_log_file}" 2>&1

decho "to get credentials: gcloud auth login"
decho "configure docker with: gcloud auth configure-docker"
decho "also: gcloud auth application-default login"
decho "remember to add your private gpg key!"
decho "remember to add your private ssh key!"
decho "set hostname using scutil: sudo scutil --set HostName <new host name>"
decho "for vmware/vagrant setup, use standalone.sh"
