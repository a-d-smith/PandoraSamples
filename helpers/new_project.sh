#!/bin/bash

# --------------------------------------------------------------------------------------------------------
# Check everything has been set-up
# --------------------------------------------------------------------------------------------------------
if [[ -z ${PANDORA_SAMPLES_IS_SETUP:+x} || -z ${PANDORA_SAMPLES_IS_INSTALLED:+x} ]]; then 
  echo "Error: Before you can run this script you must first set-up"
  echo "    source setup/setup.sh"

  return 1
fi

# --------------------------------------------------------------------------------------------------------
# Check the correct number of arguments have been passed
# --------------------------------------------------------------------------------------------------------
if [ $# -ne 1 ]; then
  echo "Error: Please pass the following arguments"
  echo "       1. A name for your new project"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Check that the project doesn't already exist
# --------------------------------------------------------------------------------------------------------
existing_projects=`find $WORKING_DIR/projects -mindepth 1 -maxdepth 1 -type d`
project_exists=false
for project in $existing_projects;
do
  if [ `basename $project` == $1 ]; then
    project_exists=true
  fi
done

if [ $project_exists == true ]; then
  echo "Error: A project with that name already exists. Please choose another name"
  echo "       You currently have the following projects"
  for project in $existing_projects;
  do
    echo "         "`basename $project`
  done
  return 0
fi

project=$1

# --------------------------------------------------------------------------------------------------------
# Check that there isn't already a directory with this project name under scratch
# --------------------------------------------------------------------------------------------------------
if [[ -d /pnfs/uboone/scratch/users/$USER_NAME/$project || -d /pnfs/uboone/scratch/users/$USER_NAME/work/$project ]]; then
  echo "Error: A directory with that name already exists in scratch. Please remove it or choose another name"
  echo "       see    /pnfs/uboone/scratch/users/$USER_NAME/$project"
  echo "       and/or /pnfs/uboone/scratch/users/$USER_NAME/work/$project"
  return 0
fi

# --------------------------------------------------------------------------------------------------------
# Make a new directory for the project
# --------------------------------------------------------------------------------------------------------
mkdir -p /pnfs/uboone/scratch/users/$USER_NAME/$project
mkdir -p /pnfs/uboone/scratch/users/$USER_NAME/work/$project
mkdir $WORKING_DIR/projects/$name
