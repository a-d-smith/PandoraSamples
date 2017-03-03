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
if [ $# -ne 3 ]; then
  echo "Error: Please pass the following arguments"
  echo "       1. An existing project name"
  echo "       2. Nuance code to filter on (can use keyword all for no filter)"
  echo "       3. cosmic or bnb?"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Check that the project exists
# --------------------------------------------------------------------------------------------------------
project=$1
if [ ! -d $WORKING_DIR/projects/$project ]; then
  echo "Error: No project with that name exists!"
  return 1
fi

# --------------------------------------------------------------------------------------------------------
# Check that a valid nuance code has been given
# --------------------------------------------------------------------------------------------------------
nuance=$2
if [[ $nuance -ne 1001 && $nuance -ne 1003 && $nuance -ne 1004 && $nuance != "all" ]]; then
  echo "Error: Please choose one of the following for your nuance code"
  echo "       1001, 1003, 1004, all"
  return 1
fi

# --------------------------------------------------------------------------------------------------------
# Check that a valid cosmic / bnb option has been given
# --------------------------------------------------------------------------------------------------------
use_cosmics=$3
if [[ $use_cosmics != "cosmic" && $use_cosmics != "bnb" ]]; then
  echo "Error: Please choose either of the following"
  echo "       cosmic - for a BNB + Cosmics sample"
  echo "       bnb    - for a pure BNB sample"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Check that this production hasn't already been started
# --------------------------------------------------------------------------------------------------------
if [ -d $WORKING_DIR/projects/$project/${use_cosmics}_${nuance} ]; then
  echo "Error: This production already exists for the project specified"
  echo "       $WORKING_DIR/projects/$project/${use_cosmics}_${nuance}"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Make the directory for this production and make the production chain
# --------------------------------------------------------------------------------------------------------
production_dir=$WORKING_DIR/projects/$project/${use_cosmics}_${nuance}
mkdir $production_dir

prod_chain=$production_dir/prod_chain_${project}_${use_cosmics}_${nuance}.xml

if [ $nuance == "all" ]; then
  cp $WORKING_DIR/generic/xml/prod_chain_generic_nofilter.xml $prod_chain
else
  cp $WORKING_DIR/generic/xml/prod_chain_generic.xml $prod_chain
fi

sed -i 's|LARSOFTVERSION|'"${MY_VERSION}"'|g' $prod_chain
sed -i 's|LARSOFTQUAL|'"${MY_COMP}"':'"${MY_TYPE}"'|g' $prod_chain
sed -i 's|PROJECT|'"${project}"'|g' $prod_chain
sed -i 's|USECOSMICS|'"${use_cosmics}"'|g' $prod_chain
sed -i 's|NUANCE|'"${nuance}"'|g' $prod_chain
sed -i 's|USERNAME|'"${USER_NAME}"'|g' $prod_chain

# Here we copy over the FCL files in case the use wants to modify them for a single production

# Copy over the GEN fcl file
cp $WORKING_DIR/generic/fcl/my_gen_${use_cosmics}_${nuance}.fcl $production_dir/.
sed -i 's|GENFCL|'"${production_dir}"'/my_gen_'"${use_cosmics}"'_'"${nuance}"'.fcl|g' $prod_chain

# Copy over the FILTER fcl file (if required)
if [ $nuance != "all" ]; then
  cp $WORKING_DIR/generic/fcl/my_filter_${nuance}.fcl $production_dir/.
  cp $WORKING_DIR/generic/fcl/my_filter_settings.fcl $production_dir/.
  sed -i 's|FILTERFCL|'"${production_dir}"'/my_filter_'"${nuance}"'.fcl|g' $prod_chain
fi

# Copy over the PNDR fcl file
cp $WORKING_DIR/generic/fcl/my_pndr.fcl $production_dir/.
cp $WORKING_DIR/generic/xml/MyPandoraSettings_Write_cosmic1.xml $production_dir/.
cp $WORKING_DIR/generic/xml/MyPandoraSettings_Write_cosmic2.xml $production_dir/.
sed -i 's|PNDRFCL|'"${production_dir}"'/my_pndr.fcl|g' $prod_chain

