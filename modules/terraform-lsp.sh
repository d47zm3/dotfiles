#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="tfenv"
readonly module_log_file="${script_dir}/log/${module_name}.log"

terraform_lsp_url="https://github.com/juliosueiras/terraform-lsp/releases/download/v0.0.11-beta2/terraform-lsp_0.0.11-beta2_darwin_amd64.tar.gz"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if ! command_exists terraform-lsp
then
  curl -sL -o terraform-lsp.tar.gz "${terraform_lsp_url}"
  tar xzf terraform-lsp.tar.gz terraform-lsp
  mv "terraform-lsp" "/usr/local/bin/"
else
  decho "skipping ${module_name} setup... binary found"
fi
