#!/usr/bin/env bash

if [[ -n $1 ]]; then
  if [[ $1 == "--help" ]]; then
      echo "create-from-template.sh [project name]"
      exit
  fi
fi

if [[ -z $1 ]]; then
  echo "please give project name as first argument"
  exit
fi

# uncomment if needs to be installed
#./install-or-update-nest-command.sh

# set variables
FULL_PATH=$1
PROJECT_NAME=${FULL_PATH##*/}
PARENT_DIR=${FULL_PATH%/*}

SCRIPT_PATH="${0%/*}"

# create new flutter project
flutter create --platforms=android,ios $PROJECT_NAME


cp -a $SCRIPT_PATH/lib ./$PROJECT_NAME

echo "done!"
