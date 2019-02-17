#!/bin/bash

function decho
{
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

> .dotfiles.log

function brew_check
{
  if ! which -s brew
  then
    decho "install brew - package manager for macos"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >> .dotfiles.log 2>&1
  fi

  brew update >> .dotfiles.log 2>&1
  brew upgrade >> .dotfiles.log 2>&1
}

function brew_cask_base
{
  decho "install brew cask and osxfuse..."
  if ! brew install cask >> .dotfiles.log 2>&1
  then
    decho "[error] brew install cask returned an error!"
  fi

  if ! brew cask install osxfuse >> .dotfiles.log 2>&1
  then
    decho "[error] brew cask install osxfuse returned an error!"
  fi
}

function brew_apps
{
  decho "install lots of brew utils..."
  brew install  vault \
                vim  \
                kops \
                kubernetes-helm \
                kube-ps1 \
                wget \
                git \
                kubectx \
                htop \
                jq \
                tnftp \
                tnftpd \
                telnet \
                telnetd \
                npm \
                watch \
                awscli \
                coreutils \
                gpg \
                p7zip \
                mysql \
                stern \
                go \
                ntfs-3g \
                tree \
                ansible \
                ansifilter \
                terraform \
                kubectl \
                nmap \
                geoip \
                bash-completion \
                git-crypt \
                speedtest_cli \
                zsh \
                zsh-completions \
                httpie \
                git-extras \
                fzf \
                tmux \
                openvpn \
                gnupg \
                pinentry-mac \
                shellcheck \
                gnu-sed \
                minisign \
                docker \
                bat >> .dotfiles.log 2>&1
    if [[ ${?} -ne 0 ]]
    then
      decho "[error] brew install ... (lots of tools) returned an error!"
    fi
}

function brew_cask_apps
{
  decho "install brew cask apps..."
  brew cask install google-chrome \
                    firefox \
                    iterm2 \
                    minikube \
                    virtualbox \
                    spotify \
                    spotify-notifications \
                    vlc \
                    dropbox \
                    evernote \
                    visual-studio-code \
                    slack \
                    dash \
                    vagrant \
                    alfred \
                    mattermost \
                    burp-suite \
                    visual-studio-code \
                    1password \
                    nordvpn \
                    backblaze \
                    flux \
                    little-snitch \
                    keybase \
                    java \
                    docker >> .dotfiles.log 2>&1

    if [[ ${?} -ne 0 ]]
    then
      decho "[error] brew cask install ... (lots of tools) returned an error!"
    fi
}

function customs
{
  if ! which -s mac
  then
    decho "install mac-cli"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)" >> .dotfiles.log 2>&1
  fi

  if [[ ${?} -ne 0 ]]
  then
    decho "[error] install mac-cli returned an error!"
  fi

  if [[ ! -d ~/.oh-my-zsh ]]
  then
    decho "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" >> .dotfiles.log 2>&1
    if [[ ${?} -ne 0 ]]
    then
      decho "[error] install oh-my-zsh returned an error!"
    fi
  fi

  if [[ ! -d ~/.tmux/plugins/tpm ]]
  then
    decho "installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
  then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi

  if [ ! -f ~/.fzf.zsh ]
  then
    $(brew --prefix)/opt/fzf/install
  fi

  if [ ! -f /usr/local/bin/cheat ]
  then
    cp $( pwd )/bin/cheat /usr/local/bin/
  fi

  sudo brew services start openvpn

  git -C "$(brew --repo homebrew/core)" fetch --unshallow

  decho "hardening system (mOSL)..."
  cd /tmp/
  git clone https://github.com/0xmachos/mOSL.git
  cd mOSL
  /tmp/mOSL/Lockdown audit
  decho "audit done, after setup run $( pwd)/Lockdown fix (remember to give full disk access to terminal app!"
}

function gpg_setup
{
  decho "set up gpg..."
  mkdir -p ~/.gnupg/
  echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  cp gpg.conf ~/.gnupg/gpg.conf
  gpg --list-secret-keys --keyid-format LONG
  decho "remember to add your private gpg & ssh key!"
}

function git_setup
{
  decho "set up git..."
  git config --global user.name "Damian Tykalowski"
  git config --global user.email d47zm3@gmail.com
  git config --global core.editor vim
  git config --global user.signingkey DD1D600D4228ED66 
  git config --global commit.gpgsign true 
  git config --global tag.forceSignAnnotated true
  rm -f ~/.gitignore_global
  ln -s $( pwd )/gitignore ~/.gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  git config --list
}

function ctf_tools
{
  decho "installing ctf tools..."
  brew install  aircrack-ng \
                bfg \
                binutils \
                binwalk \
                cifer \
                dex2jar \
                dns2tcp \
                fcrackzip \
                foremost \
                hashpump \
                hydra \
                john \
                knock \
                netpbm \
                nmap \
                pngcheck \
                socat \
                sqlmap \
                tcpflow \
                tcpreplay \
                tcptrace \
                xpdf \
                xz >> .dotfiles.log 2>&1

    if [[ ${?} -ne 0 ]]
    then
      decho "[error] brew install ctf tools returned an error!"
    fi
}

function cleanup
{
  decho "cleanup..."
  brew cleanup >> .dotfiles.log 2>&1
  rm -rf ~/mac-cli
}

function macos_settings
{
 source .macos
}

function dotfiles
{
  rm -f ~/.vimrc
  rm -f ~/.tmux.conf
  rm -f ~/.zshrc
  rm -f ~/.zshrc.extra
  rm -f ~/.oh-my-zsh/themes/minimal.zsh-theme
  ln -s $( pwd )/tmux.conf  ~/.tmux.conf
  ln -s $( pwd )/vimrc  ~/.vimrc
  ln -s $( pwd )/zshrc ~/.zshrc
  ln -s $( pwd )/zshrc.extra ~/.zshrc.extra
  ln -s $( pwd )/minimal.zsh-theme ~/.oh-my-zsh/themes/minimal.zsh-theme
}

echo "[~] dotfiles"
decho "setting up system..."
brew_check
#brew_cask_base
brew_apps
#brew_cask_apps
#ctf_tools
#dotfiles
#customs
git_setup
#macos_settings
#cleanup
