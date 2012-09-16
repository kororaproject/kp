#!/bin/bash

# Copyright 2012 "Korora Project" <dev@kororaproject.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the temms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#This script is for building packages for Korora

# I think this should be a menu, longer term

# Variables, these can be overridden in kp.conf or package.kp
VERSION=0.1
#CONFIG_DIR=/etc/kp
CONFIG_DIR=/home/chris/code/korora/kp/conf
ANON="true"
DEPS="git mock" #list of dependencies
GIT_URL=""
GIT_URL_DEV=""
PACKAGE="" #read in from args
TMP_DIR="$HOME/kp"

# Functions
function usage()
{
cat << EOF
usage: $0 options

The following options are available:

   -h      Show this message
   -d      Use developer account to build, else anonymous
   -l      List all available packages
   -p      List of packages to build ("all" for all packages)
   -y      Assume yes to all questions (no prompt)
EOF
}

function list_packages {
  echo "The following packages are available:"
  grep "^KP_NAME=" $CONFIG_DIR/*.kp  |awk -F "=" {'print $2'}
}

function check_deps {
  LIST=""
  for x in $* ; do command -v $x >/dev/null 2>&1 || LIST="$LIST $x" ; done
}


function clean_tmp_dir {
  rm -Rf "$TMP_DIR/$1"
}

function git_clone {
  cd $TMP_DIR
  git clone $GIT_URL/$1
}

# Source config file
#source $CONFIG_DIR/kp.conf
source /home/chris/code/korora/kp/conf/kp.conf

while getopts "dhlp:y" ARGS
do
  case $ARGS in
    h)
      usage
      exit 1
      ;;
    l)
      list_packages
      exit 0
      ;;
    d)
      ANON=false
      ;;
    p)
      PACKAGE="$PACKAGE$OPTARG "
      ;;
    y)
      NO_PROMPT=yes
      ;;
    ?)
      usage
      exit 0
     ;;
  esac
done

if [ -z "$*" ]
then
  usage
  exit 0
fi

if [ -z "$PACKAGE" ]
then
  echo "You must give me a package to build."
  exit 1
else
  for x in $PACKAGE
  do
    if [ -z "$(grep KP_NAME=$x $CONFIG_DIR/*.kp)" ]
    then
      echo "Sorry, I can't find the $x config file, exiting."
      exit 1
    fi
  done
fi

# Source name of package we want to build (can override variables here)
#source $CONFIG_DIR/$PACKAGE.kp
for x in $PACKAGE
do
  source /home/chris/code/korora/kp/conf/$x.kp
done

# Are we anonymous?
if [ "$ANON" == "false" -o "$ANON" == "False" ]
then
  GIT_URL="$GIT_URL_DEV"
fi

# Print status
echo -e "OK, we're going to build the following:\n$PACKAGE"

if [ -n "$(grep -i "false" <<< "$ANON")" ]
then
  echo -e "\nAnd you claim to be a developer (so we're going to commit build version)."
fi

if [ -z "$NO_PROMPT" ]
then
  echo -e "\nWant to continue? y/N:"
  read answer
  if [ -z "$(grep -i "y" <<< "$answer")" ]
  then
    exit 1
  fi
fi

#check tmp dir - of not in home dir this should be created by rpm and have stickybit set
if [ ! -e "$TMP_DIR" ]
then
  mkdir -p $TMP_DIR
  #need to sort out permissions, like mock?
else
  if [ ! -d "$TMP_DIR" ]
  then
    echo "Temporary directory $TMP_DIR does not appear to be a directory, exiting"
    exit 1
  fi
fi

#check_deps #need to make sure we have all the tools we need, like git, mock, etc.
check_deps $DEPS fake_dependency
if [ -n $LIST ]
then
  echo "You're missing the following dependencies:\n$LIST"
  echo "\nWould you like to install them? n/Y"
  read answer
  if [ -n "$(grep -i "n" <<< "$answer")" ]
  then
    exit 1
  else
    echo "Enter root's password:"
    su -c "yum install $LIST"
    if [ $? -ne 0 ]
    then
      echo "Failed to install all dependencies, exiting."
      exit 1
    fi
  fi
fi

for x in $PACKAGE
do
  clean_tmp_dir $x
  git_clone $x
  prepare_package $x
  build_package $x
done

