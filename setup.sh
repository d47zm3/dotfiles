#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

brew_apps=( "vault" "sops" "nvim" "kops" "cfssl" "kubernetes-helm" "kube-ps1" "wget" "git" "kubectx" "htop" "jq" "tnftp" "tnftpd" "telnet" "telnetd" "npm" "nodejs" "watch" "awscli" "coreutils" "gpg" "p7zip" "mysql" "stern" "go" "ntfs-3g" "tree" "ansible" "ansifilter" "terraform" "kubectl" "nmap" "geoip" "bash-completion" "git-crypt" "speedtest_cli" "zsh" "zsh-completions" "httpie" "git-extras" "fzf" "tmux" "openvpn" "gnupg" "pinentry-mac" "shellcheck" "gnu-sed" "minisign" "hugo" "docker" "dep" "hadolint" "bat" "openconnect" "tmux-mem-cpu-load" "yamllint" "dive" "terraformer")
brew_cask_apps=( "google-chrome" "firefox" "iterm2" "java" "spotify" "vlc" "visual-studio-code" "slack" "vagrant" "mattermost" "burp-suite" "1password" "nordvpn" "flux" "notion" "docker" "appgate-sdp-client" "discord" "postman")

decho() {
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

init() {
  decho "setting up system..."
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
}

command_exists() {
  command -v "$1" &> /dev/null
}

brew_check() {
  decho "checking if brew exists"
  if ! command_exists brew
  then
    decho "installing brew"
    CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else
    decho "brew installed"
  fi

  brew update
  brew upgrade
}

brew_cask_base() {
  decho "install brew cask and osxfuse..."
  if ! brew install cask
  then
    decho "[error] brew install cask returned an error!"
  fi

  if ! brew cask install osxfuse
  then
    decho "[error] brew cask install osxfuse returned an error!"
  fi
}

brew_apps() {
  decho "install brew utils..."
  if ! brew install "${brew_apps[@]}"
  then
    decho "[error] brew install ... (lots of tools) returned an error!"
  fi
}

brew_cask_apps() {
  decho "install brew cask apps..."
  if ! brew cask install "${brew_cask_apps[@]}"
  then
    decho "[error] brew cask install ... (lots of tools) returned an error!"
  fi
}

brew_setup() {
  brew_check
  brew_cask_base
  brew_apps
  brew_cask_apps
  brew install nektos/tap/act
}

install_oh_my_zsh() {
  if [[ ! -d ~/.oh-my-zsh ]]
  then
    decho "install oh-my-zsh..."
    curl -sLo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    if ! sh install.sh --unattended
    then
      decho "[error] install oh-my-zsh returned an error!"
    fi
    rm -f install.sh
  fi
}

install_tpm() {
  if [[ ! -d ~/.tmux/plugins/tpm ]]
  then
    decho "installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

install_zsh_addons() {
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
  fi
}

install_fzf() {
  $(brew --prefix)/opt/fzf/install --all
}

install_gcloud_sdk() {
  curl https://sdk.cloud.google.com > install.sh
  bash install.sh --disable-prompts
  decho "to get credentials: gcloud auth application-default login"
}

install_fonts() {
  decho "install ubuntu fonts..."
  cd /tmp || exit
  curl -s https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip -o fonts.zip
  unzip fonts.zip
  cd ubuntu-font-family-0.83 || exit
  cp ./*.ttf ~/Library/Fonts/
  cd .. || exit
  rm -rf ubuntu-font-family-0.83
}

setup_others() {
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  chsh -s /bin/zsh
}

gpg_setup() {
  cd "${script_dir}" || exit
  decho "set up gpg..."
  gpg --list-keys
  echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  cp ./gpg/gpg.conf ~/.gnupg/gpg.conf
  chown -R d47zm3:staff ~/.gnupg
  curl -s https://keybase.io/d47zm3/pgp_keys.asc | gpg --import
  gpg --list-secret-keys --keyid-format LONG
  decho "remember to add your private gpg key!"
}

git_setup() {
  cd "${script_dir}" || exit
  decho "set up git..."
  git config --global user.name "Damian Tykalowski"
  git config --global user.email d47zm3@gmail.com
  git config --global core.editor vim
  git config --global user.signingkey DD1D600D4228ED66
  git config --global commit.gpgsign true
  git config --global tag.forceSignAnnotated true
  rm -f ~/.gitignore_global
  cp ./git/gitignore ~/.gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  git config --list
  decho "remember to add your private ssh key!"
}

setup_nvim() {
  cd "${script_dir}" || exit
  mkdir -p ~/.config/nvim/
  cp ./nvim/init.vim  ~/.config/nvim/
  cp ./nvim/coc-settings.json  ~/.config/nvim/
  nvim --headless +PlugInstall +qall
  nvim --headless +GoUpdateBinaries +qall
}

customs() {
  install_oh_my_zsh
  install_zsh_addons
  install_tpm
  install_fzf
  install_gcloud_sdk
  install_fonts
  setup_nvim
  git_setup
  gpg_setup
  setup_others
}

cleanup() {
  decho "cleanup..."
  brew cleanup
  decho "enable spctl master switch..."
  sudo spctl --master-enable
  decho "set up your stuff and continue with manual script..."
}

dotfiles() {
  cd "${script_dir}" || exit
  cp ~/.tmux.conf ~/.tmux.conf.orig.$( date +%s )
  cp ~/.zshrc ~/.zshrc.orig.$( date +%s )
  cp ~/.zshrc.extra ~/.zshrc.extra.orig.$( date +%s )
  cp ~/.oh-my-zsh/themes/minimal.zsh-theme ~/.oh-my-zsh/themes/minimal.zsh-theme.orig.$( date +%s )
  cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.$( date +%s )
  cp ~/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json.$( date +%s )
  rm -f ~/.tmux.conf
  rm -f ~/.zshrc
  rm -f ~/.zshrc.extra
  rm -f ~/.oh-my-zsh/themes/minimal.zsh-theme
  rm -f ~/.config/nvim/init.vim
  rm -f ~/.config/nvim/coc-settings.json
  ln -s "${script_dir}/tmux/tmux.conf" ~/.tmux.conf
  ln -s "${script_dir}/zsh/zshrc" ~/.zshrc
  ln -s "${script_dir}/zsh/zshrc.extra" ~/.zshrc.extra
  ln -s "${script_dir}/zsh/minimal.zsh-theme" ~/.oh-my-zsh/themes/minimal.zsh-theme
  ln -s "${script_dir}/nvim/init.vim"  ~/.config/nvim/init.vim
  ln -s "${script_dir}/nvim/coc-settings.json"  ~/.config/nvim/coc-settings.json

  decho "remember to switch dotfiles to your git repository after completing setup!"
}

main() {
  init
  brew_setup
  customs
  dotfiles
  cleanup
}

main
