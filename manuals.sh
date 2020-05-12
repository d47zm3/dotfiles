#!/usr/bin/env bash

vagrant_vmware_license=""
keys=""

decho() {
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
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
  vagrant plugin license vagrant-vmware-desktop "${vagrant_vmware_license}"
}

setup_dirs() {
  mkdir -p "$HOME/Projects/"
  cd "$HOME/Projects" || exit
  ln -s "$HOME/Seafile/Personal" Personal
  ln -s "$HOME/Seafile/Work" Work
  cd Personal || exit
  ln -s $( pwd )/go ~/go
}

main() {
  setup_dirs
  install_virtualbox
  install_vmware_fusion
}

main "${@}"
