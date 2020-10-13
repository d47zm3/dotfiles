#!/usr/bin/env bash

# shellcheck disable=SC1091
source /dev/stdin <<<"$( curl -sS https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh )"

script_dir="${1}"
readonly module_name="gcloud-sdk"
readonly module_log_file="${script_dir}/log/${module_name}.log"

decho "initialising ${module_name} module..."
true > "${module_log_file}"

if [[ ! -e "$HOME/google-cloud-sdk/bin/gcloud" ]]
then
  decho "installing gcloud sdk..."

  curl -s https://sdk.cloud.google.com > install.sh
  if ! bash install.sh --disable-prompts >> "${module_log_file}" 2>&1
  then
    decho "[error] there was an error during gcloud sdk installation..."
  fi
  decho "to get credentials: gcloud auth login"
  decho "configure docker with: gcloud auth configure-docker"
  decho "also: gcloud auth application-default"
else
  decho "gcloud sdk already installed!"
fi
