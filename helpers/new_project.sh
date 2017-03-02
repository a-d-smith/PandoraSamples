#!/bin/bash

# --------------------------------------------------------------------------------------------------------
# Check everything has been set-up
# --------------------------------------------------------------------------------------------------------
if [[ -z ${PANDORA_SAMPLES_IS_SETUP:+x} || -z ${PANDORA_SAMPLES_IS_INSTALLED:+x} ]]; then 
  echo "Error: Before you can run this script you must first set-up"
  echo "    source setup/setup.sh"

  return 1
fi
