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
  echo "       1. An XML file"
  echo "       2. Stage (GEN, FILTER, G4, DETSIM, PNDR)"
  echo "       3. Number of events"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Check that the XML file exists
# --------------------------------------------------------------------------------------------------------
file=$1
if [ ! -f $file ]; then
  echo "Error: No file exists with that name!"
  return 1
fi

# --------------------------------------------------------------------------------------------------------
# Check that a valid stage has been given
# --------------------------------------------------------------------------------------------------------
stage=$2
if [[ $stage != "GEN" && $stage != "FILTER" && $stage != "G4" && $stage != "DETSIM" && $stage != "PNDR" ]]; then
  echo "Error: Please choose one of the following for your stage"
  echo "       GEN, FILTER, G4, DETSIM, PNDR"
  return 1
fi


# --------------------------------------------------------------------------------------------------------
# Now find any lines that contain <?${stage}EVENTS?>
# --------------------------------------------------------------------------------------------------------
rm -rf ${file}_modified
touch ${file}_modified
search="<?${stage}EVENTS?>"
while read line; do
  if [[ $line == *$search* ]]; then
    echo "<numevents>${3}</numevents> ${search}" >> ${file}_modified
  else
    echo $line >> ${file}_modified
  fi
done < $file
mv ${file}_modified ${file}
