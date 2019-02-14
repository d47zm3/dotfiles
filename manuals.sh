#!/usr/bin/env bash

temporary_dir="$HOME/Temporary"
vagrant_vmware_license="$HOME/Dropbox/Miscellanous/Vagrant-VMWare-Desktop/license.lic"
keys="$HOME/Dropbox/Miscellanous/Private/keys.zip"

decho() {
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

if [ ! -e "${vagrant_vmware_license}" ] || [ ! -e "${keys}" ]; then
  decho "Dropbox Not Synced!"
  exit 1
fi

decho "unpack keys..."
mkdir -p "${temporary_dir}"
cp "${keys}" "${temporary_dir}"
unzip -q "${temporary_dir}/$(basename ${keys})"

decho "install vmware plugin license"

brew cask install virtualbox vmware-fusion
vagrant plugin install vagrant-vmware-desktop
vagrant plugin license vagrant-vmware-desktop "$HOME/Dropbox/Miscellanous/Vagrant-VMWare-Desktop/license.lic"

rm -f "${temporary_dir}"
