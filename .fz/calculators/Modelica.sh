#!/bin/bash

# if directory as input, cd into it
if [ -d "$1" ]; then
  cd "$1"
  MO_FILE=`ls *.mo | head -n 1`
  shift
# if $* are files, find the .mo file
elif [ $# -gt 1 ]; then
  MO_FILE=""
  for f in "$@"; do
    if [ `echo $f | grep -c '\.mo$'` -eq 1 ]; then
      MO_FILE="$f"
      break
    fi
  done
  if [ -z "$MO_FILE" ]; then
    echo "No .mo file found in input files. Exiting."
    exit 1
  fi
  shift $#
else
  MO_FILE="$1"
fi

# Check if the file is a .mos script or a .mo model
if [ ! "${MO_FILE: -4}" == ".mos" ]; then
  model=`grep "model" $MO_FILE | awk '{print $2}' | head -n 1`
  cat > $MO_FILE.mos <<- EOM
loadModel(Modelica);
loadFile("$MO_FILE");
simulate($model, outputFormat="csv");
EOM
  omc $MO_FILE.mos > $MO_FILE.moo 2>&1 &
else
  omc $MO_FILE > $MO_FILE.moo 2>&1 &
fi

PID_OMC=$!
echo $PID_OMC >> PID #this will allow fz to kill process if needed

wait $PID_OMC

rm -f PID

ERROR=`cat *.moo | grep "Failed"`
if [ ! "$ERROR" == "" ]; then
    echo $ERROR >&2
    exit 1
fi
