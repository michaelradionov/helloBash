#!/bin/bash
set -e

# Colors
green='\033[1;32m'       # 1 Green
black='\033[1;30m'       # 2 Black
red='\033[1;31m'         # 3 Red
yellow='\033[1;33m'      # 4 Yellow
blue='\033[1;34m'        # 5 Blue
purple='\033[1;35m'      # 6 Purple
cyan='\033[1;36m'        # 7 Cyan
white='\033[1;37m'       # 8 White
NC='\033[0m'             # Text Reset

colors=($black $red $yellow $blue $purple $cyan $white)

function listColors () {
  for index in ${!colors[*]}
  do
      echo -e ${colors[$index]} $index $NC
  done
}
function random () {
  echo $(( ( RANDOM % 7 )  + 0 ))
}

echo "Hello! This is PS1 installer!"

#
# NAME
#
read -p "User Name? (empty for system value): " user_name
if [ -z $user_name ]; then
  user_name='\u';
fi

listColors
read -p "User name color? (1-8): " user_name_color
if [ -z $user_name_color ]; then
  user_name_color=$(random)
fi

user_name='\['${colors[$user_name_color]}'\]'${user_name}'\['${NC}'\]'

# Your host
read -p "Host Name? (empty for system value): " host_name
if [ -z $host_name ]; then
  host_name='\h';
fi

listColors
read -p "Host name color? (1-8): " host_name_color
if [ -z $host_name_color ]; then
  host_name_color=$(random)
fi

host_name='\['${colors[$host_name_color]}'\]@'${host_name}'\['${NC}'\]'

# Show path?
read -p "Do you want your path in PS1 (empty for yes, 'n' for no): " show_path

# Your path color
if [ -z $show_path ]; then
  listColors
  read -p "Host path color? (1-8): " host_path_color
  if [ -z $host_path_color ]; then
    host_path_color=$(random)
  fi
  path='\['${colors[$host_path_color]}'\]\W\['${NC}'\]'
else
  path=''
fi

PS1=" ${user_name}${host_name} ${path} "

BEGIN='HELLO_BASH_BEGIN'
END='HELLO_BASH_END'
SOURCE=$PS1


#
#
# Showing command execution status to user
#
#

check_command_exec_status () {
  if [ $1 -eq 0 ]
    then
      echo -e "${yellow}SUCCESS!${NC}"
      echo
      sleep 1
  else
    echo -e "${red}ERROR${NC}"
    echo

  fi
}

#
#
# INSTALLER
#
#


  TOTAL_LINES=`cat ~/.bashrc | wc -l`
  BEGIN_LINE=`grep -n -e ${BEGIN} ~/.bashrc | cut -d : -f 1`
  END_LINE=`grep -n -e ${END} ~/.bashrc | cut -d : -f 1`
  TAIL_LINES=$(($TOTAL_LINES-$END_LINE + 1))

  # Can't find both GGA markers
  if [[ ! $BEGIN_LINE ]] && [[ ! $END_LINE ]] || [[ $BEGIN_LINE ]] && [[ $END_LINE ]]
  then
    echo ''
    echo -e "All right! Let's do it!";
    echo ''
    echo "Making backup of your '~/.bashrc' in ~/.bashrc.backup ...";
    echo ''
    cp ~/.bashrc ~/.bashrc.backup
    check_command_exec_status $?
    echo ''
    echo "Installing in 3 steps ...";
    echo ${BEGIN}>> ~/.bashrc
    check_command_exec_status $?
    curl -L -s ${SOURCE} >> ~/.bashrc
    check_command_exec_status $?
    echo ${END}>> ~/.bashrc
    check_command_exec_status $?
    # . ~/.bashrc

    echo 'Self-terminating'
    rm -f ${0##*/}
    check_command_exec_status $?
    echo -e "Now restart your terminal or run this (yes, dot is a command):"
    echo ""
    echo -e "${cyan}. ~/.bashrc${NC}";
    echo ""
    exit 0;
  fi

  # One of markers is broken
  if [[ ! $BEGIN_LINE ]] || [[ ! $END_LINE ]]
  then
    echo -e "It looks like one of two GGA markers is broken. Hmm.. I guess you'll need to fix it yourself.\n You must check that ${red}${BEGIN}${NC} is placed in the beginning and ${red}${END}${NC}  in the end of Go Git Aliases block.\n Self-terminating.";
    rm -f ${0##*/}
    check_command_exec_status $?
    exit 0;
  fi
