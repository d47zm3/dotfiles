#!/usr/bin/env bash

temporary_dir="$HOME/Temporary"
vagrant_vmware_license="$HOME/Dropbox/Miscellanous/Vagrant-VMWare-Desktop/license.lic"
keys="$HOME/Dropbox/Miscellanous/Private/keys.zip"

decho() {
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

check_sync_status() {
  if [ ! -e "${vagrant_vmware_license}" ] || [ ! -e "${keys}" ]; then
    decho "Dropbox Not Synced!"
    exit 1
  fi
}

setup_keys() {
  decho "setup keys..."
  mkdir -p "${temporary_dir}"
  cp "${keys}" "${temporary_dir}"
  unzip -q "${temporary_dir}"/"$(basename "${keys}")"
  cp "${temporary_dir}/id_rsa*" "$HOME/.ssh/"
  gpg --import "${temporary_dir}/gpg.key"
  rm -f "${temporary_dir}"
}

install_virtualbox() {
  brew cask install virtualbox
  decho "allow oracle extension in system settings..."
  read -s -n -r 1
}

install_vmware_fusion() {
  decho "install vmware plugin license"
  brew cask install vmware-fusion
  vagrant plugin install vagrant-vmware-desktop
  vagrant plugin license vagrant-vmware-desktop "$HOME/Dropbox/Miscellanous/Vagrant-VMWare-Desktop/license.lic"
}

setup_dirs() {
  mkdir -p "$HOME/Projects/"
  cd "$HOME/Projects" || exit
  ln -s "$HOME/Dropbox/Projects/Personal" Personal
  ln -s "$HOME/Dropbox/Projects/Work" Personal
  ln -s "$HOME/go" Go
}

main() {
  check_sync_status
  setup_keys
  setup_dirs
  install_virtualbox
  install_vmware_fusion
}

main "${@}"
