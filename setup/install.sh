#!/bin/bash

# --------------------------------------------------------------------------------------------------------
# Settings for the filter module
# --------------------------------------------------------------------------------------------------------

# Which branch to use (see https://github.com/loressa/myfiltermodule/branches for the options)
# Until the fix gets merged, we are actually using a forked repo at 
# https://github.com/a-d-smith/myfiltermodule/branches
MY_FILTER_BRANCH=v6

# --------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------
# Check everything has been set-up
# --------------------------------------------------------------------------------------------------------
if [ -z ${PANDORA_SAMPLES_IS_SETUP:+x} ]; then 
  echo "Error: Before you can run this script you must first set-up"
  echo "    source setup/setup.sh"

  return 1
fi

# --------------------------------------------------------------------------------------------------------
# Get a local development area for LArSoft
# --------------------------------------------------------------------------------------------------------

echo "Getting a local development area for LArSoft ${MY_VERSION}"
printf '=%.0s' {1..80}; printf '\n'

if [ -d ${WORKING_DIR}/LArSoft-${MY_VERSION} ]; then
  echo "Error: Installation directory already exists!"
  echo "  rm -rf ${WORKING_DIR}/LArSoft-${MY_VERSION}"
  return 1
fi

mkdir ${WORKING_DIR}/LArSoft-${MY_VERSION}
cd ${WORKING_DIR}/LArSoft-${MY_VERSION}
mrb newDev
source localProducts*/setup

# --------------------------------------------------------------------------------------------------------
# Install Lorena's filter module
# --------------------------------------------------------------------------------------------------------

echo "Installing the filter module with branch ${MY_FILTER_BRANCH}"
printf '=%.0s' {1..80}; printf '\n'

cd $MRB_SOURCE
mrb g https://github.com/loressa/myfiltermodule.git
cd myfiltermodule
git checkout $MY_FILTER_BRANCH
mrb uc

cd $MRB_BUILDDIR
mrbsetenv
mrb i 
mrbslp

# --------------------------------------------------------------------------------------------------------
# Make the tarball
# --------------------------------------------------------------------------------------------------------
cd $WORKING_DIR/generic
tar -C $MRB_INSTALL -czf local.tar .

cd $WORKING_DIR
export PANDORA_SAMPLES_IS_INSTALLED=0



