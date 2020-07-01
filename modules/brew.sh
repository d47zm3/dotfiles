#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="brew"
readonly module_log_file="${script_dir}/log/${module_name}.log"

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

post_brew_cask_apps=(
  "ntfs-3g"
  )

brew_apps=(
  "pipenv"
  "dockutil"
  "vault"
  "sops"
  "nektos/tap/act"
  "nvim"
  "kops"
  "cfssl"
  "kubernetes-helm"
  "kube-ps1"
  "wget"
  "git"
  "kubectx"
  "htop"
  "jq"
  "tnftp"
  "tnftpd"
  "telnet"
  "telnetd"
  "npm"
  "nodejs"
  "watch"
  "awscli"
  "coreutils"
  "gpg"
  "p7zip"
  "mysql"
  "stern"
  "go"
  "tree"
  "ansible"
  "ansifilter"
  "terraform"
  "kubectl"
  "nmap"
  "geoip"
  "bash-completion"
  "git-crypt"
  "zsh"
  "zsh-completions"
  "httpie"
  "git-extras"
  "fzf"
  "tmux"
  "openvpn"
  "gnupg"
  "pinentry-mac"
  "shellcheck"
  "gnu-sed"
  "minisign"
  "hugo"
  "docker"
  "dep"
  "hadolint"
  "bat"
  "openconnect"
  "tmux-mem-cpu-load"
  "yamllint"
  "dive"
  "terraformer"
  "mas"
  "geckodriver"
  "syncthing"
  "ripgrep"
)

brew_cask_apps=(
  "google-chrome"
  "nordvpn"
  "firefox"
  "iterm2"
  "java"
  "spotify"
  "vlc"
  "visual-studio-code"
  "slack"
  "vagrant"
  "mattermost"
  "burp-suite"
  "1password"
  "nordvpn"
  "flux"
  "notion"
  "docker"
  "appgate-sdp-client"
  "discord"
  "postman"
  "chromedriver"
  "logitech-options"
  "logitech-unifying"
  "vmware-fusion"
  "osxfuse"
  "wireshark"
  )

brew_taps=(
  "homebrew/cask-drivers"
)

decho "initialising ${module_name} module..."

mkdir -p "${script_dir}/log"
true > "${module_log_file}"

if ! command_exists brew
then
  decho "installing brew..."
  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" >> "${module_log_file}" 2>&1
else
  decho "brew already installed!"
fi

decho "installing extra taps..."
for brew_tap in "${brew_taps[@]}"
do
  if ! brew tap | grep -q "${brew_tap}"
  then
    if ! brew tap "${brew_tap}" >> "${module_log_file}" 2>&1
    then
      decho "[error] brew tap ${brew_tap} returned an error!"
    fi
  fi
done

decho "updating brew modules..."
if ! brew update >> "${module_log_file}" 2>&1
then
  decho "[error] brew update returned an error!"
fi

if ! brew upgrade >> "${module_log_file}" 2>&1
then
  decho "[error] brew upgrade returned an error!"
fi

decho "installing brew utils..."
if ! brew install "${brew_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] brew install returned an error!"
fi

decho "installing brew cask apps..."
if ! brew cask install "${brew_cask_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] brew cask install returned an error!"
fi

decho "installing post-brew cask apps..."
if ! brew install "${post_brew_cask_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] post-brew cask install returned an error!"
fi

"$(brew --prefix)/opt/fzf/install" "--all" >> "${module_log_file}" 2>&1
