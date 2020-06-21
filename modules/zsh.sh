#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="zsh"
readonly module_log_file="${script_dir}/log/${module_name}.log"

config_files=( ".zshrc" ".zshrc.extra" )
config_source_dir="${script_dir}/zsh"
config_destination_dir="${HOME}"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if command_exists zsh
then
  cd "${script_dir}" || exit

  if [[ ! -d ~/.oh-my-zsh ]]
  then
    decho "installing oh-my-zsh..."
    curl -sLo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh >> "${module_log_file}" 2>&1
    if ! sh install.sh --unattended >> "${module_log_file}" 2>&1
    then
      decho "[error] installing oh-my-zsh returned an error!"
    fi
    rm -f install.sh
  fi

  decho "installing oh-my-zsh addons..."

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" >> "${module_log_file}" 2>&1
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" >> "${module_log_file}" 2>&1
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"  >> "${module_log_file}" 2>&1
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" >> "${module_log_file}" 2>&1
  fi

  for config in "${config_files[@]}"
  do
    if [[ -e "${config_destination_dir}/${config}" ]]
      if ! cmp --silent "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
      then
        decho "source config ${config} and existing one differs, installing source one and backing up current one..."
        cp "${config_destination_dir}/${config}" "${config_destination_dir}/${config}.$( date +%s )"
        rm -f "${config_destination_dir}/${config}"
      fi
    fi
    ln -s "${config_source_dir}/${config}" "${config_destination_dir}/${config}"
  done

  decho "installing oh-my-zsh theme..."
  ln -s "${config_source_dir}/minimal.zsh-theme" "$HOME/.oh-my-zsh/themes/minimal.zsh-theme"
else
  decho "skipping ${module_name} setup... binary not found"
fi
