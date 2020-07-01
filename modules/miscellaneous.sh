#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="miscellaneous"
readonly module_log_file="${script_dir}/log/${module_name}.log"

vagrant_plugins=( "vagrant-vmware-desktop" )

decho "initialising ${module_name} module..."
true > "${module_log_file}"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/id_rsa"
chmod 600 "$HOME/.ssh/id_rsa"
mkdir -p "$HOME/Sync/Personal"
mkdir -p "$HOME/Sync/Work"

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
  else
    ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
  fi
done

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

cp "${script_dir}/${module_name}/Profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"

decho "starting syncthing service..."
brew services start syncthing >> "${module_log_file}" 2>&1

decho "tweaking macos settings..."
"${script_dir}/${module_name}/macosx" >> "${module_log_file}" 2>&1
