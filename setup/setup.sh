#!/bin/bash

# --------------------------------------------------------------------------------------------------------
# Define the LArSoft version we wish to use
# --------------------------------------------------------------------------------------------------------

export MY_VERSION=v06_26_01
export MY_COMP=e10
export MY_TYPE=prof

# --------------------------------------------------------------------------------------------------------

# The directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set-up some useful variables for later scripts
export USER_NAME=`whoami`
export WORKING_DIR=`readlink -f $SCRIPT_DIR/..`
export PANDORA_SAMPLES_IS_SETUP=true

# Setup uboonecode with the required LArSoft version
source /grid/fermiapp/products/uboone/setup_uboone.sh 
setup uboonecode ${MY_VERSION} -q ${MY_COMP}:${MY_TYPE}

# Setup for running on the grid
source /grid/fermiapp/products/common/etc/setups.sh
setup jobsub_client

# Setup our development area (if we have already installed it)
if [ -f ${WORKING_DIR}/LArSoft-${MY_VERSION}/localProducts*/setup ]; then
  source ${WORKING_DIR}/LArSoft-${MY_VERSION}/localProducts*/setup
  export PANDORA_SAMPLES_IS_INSTALLED=true
else
  export PANDORA_SAMPLES_IS_INSTALLED=false
fi

# Print the details we have found
echo "Setup complete: "
printf '=%.0s' {1..80}; printf '\n'
echo "USER_NAME       = ${USER_NAME}"
echo "WORKING_DIR     = ${WORKING_DIR}"
echo "LArSoft Version = ${MY_VERSION} ${MY_COMP}:${MY_TYPE} "
if [ ! $PANDORA_SAMPLES_IS_INSTALLED ]; then
  echo "Next... install using setup/install.sh"
fi
printf '=%.0s' {1..80}; printf '\n'
