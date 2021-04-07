#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="brew"
readonly module_log_file="${script_dir}/log/${module_name}.log"

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

local_xcode_link="http://basement.d47zm3.me:8192/Command_Line_Tools_for_Xcode_12.4.dmg"

post_brew_cask_apps=(
  "ntfs-3g"
  )

brew_cask_apps=(
  "docker"
  "wireshark"
  "flux"
  "microsoft-teams"
)

brew_apps=(
  "checkov"
  "terraform-docs"
  "terragrunt"
  "tfsec"
  "tflint"
  "pre-commit"
  "git-secrets"
  "hashicorp/tap/terraform-ls"
  "exa"
  "fd"
  "diskus"
  "hexyl"
  "yarn"
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
  "tfenv"
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
  "fluxctl"
  "kubeseal"
  "java"
  "pyenv"
  "google-chrome"
  "nordvpn"
  "firefox"
  "iterm2"
  "spotify"
  "vlc"
  "visual-studio-code"
  "slack"
  "mattermost"
  "burp-suite"
  "1password"
  "nordvpn"
  "flux"
  "notion"
  "docker"
  "discord"
  "postman"
  "chromedriver"
  "logitech-options"
  "osxfuse"
  "jsonlint"
  "google-backup-and-sync"
  "istioctl"
  "git-delta"
  )

decho "initialising ${module_name} module..."

mkdir -p "${script_dir}/log"
true > "${module_log_file}"

if ! [ -d "/Library/Developer/CommandLineTools" ]
then
  decho "xcode tools not found... trying to fetch from local server..."
  if validate_url "${local_xcode_link}"
  then
    decho "could find xcode locally & no access to local download... exit!"
    exit 1
  else
    decho "have access to local xcode tools, fetching & installing..."
    curl -s "${local_xcode_link}" --output xcode.dmg >> "${module_log_file}" 2>&1
    hdiutil attach xcode.dmg >> "${module_log_file}" 2>&1
    cd "/Volumes/Command Line Developer Tools" || exit
    sudo installer -pkg Command\ Line\ Tools.pkg -target "/" >> "${module_log_file}" 2>&1
    sleep 5
    rm -f xcode.dmg
    cd "${script_dir}" || exit
    sleep 5
    hdiutil detach "/Volumes/Command Line Developer Tools" >> "${module_log_file}" 2>&1
  fi
fi

if ! command_exists brew
then
  decho "installing brew..."
  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" >> "${module_log_file}" 2>&1
  decho "tap brew cask drivers"
  brew tap homebrew/cask-drivers >> "${module_log_file}" 2>&1
else
  decho "brew already installed!"
fi

decho "updating brew modules..."
if ! brew update >> "${module_log_file}" 2>&1
then
  decho "[error] brew update returned an error!"
fi

if ! brew upgrade >> "${module_log_file}" 2>&1
then
  decho "[error] brew upgrade returned an error!"
fi

decho "installing brew pre-utils..."
brew install --cask osxfuse >> "${module_log_file}" 2>&1
decho "installing brew utils..."
if ! brew install "${brew_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] brew install returned an error!"
fi

decho "installing brew --cask utils..."
if ! brew --cask install "${brew_cask_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] brew --cask install returned an error!"
fi

decho "installing post-brew cask apps..."
if ! brew install "${post_brew_cask_apps[@]}" >> "${module_log_file}" 2>&1
then
  decho "[error] post-brew cask install returned an error!"
fi

"$(brew --prefix)/opt/fzf/install" "--all" >> "${module_log_file}" 2>&1
