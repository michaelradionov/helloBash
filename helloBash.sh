#!/bin/bash
# set -e

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

BEGIN='### HELLO_BASH_BEGIN'
END='### HELLO_BASH_END'

TOTAL_LINES=`cat ~/.bashrc | wc -l`
BEGIN_LINE=`grep -n -e "${BEGIN}" ~/.bashrc | cut -d : -f 1`
END_LINE=`grep -n -e "${END}" ~/.bashrc | cut -d : -f 1`
TAIL_LINES=$(($TOTAL_LINES-$END_LINE+1))

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

function helloBash () {

#
# UNINSTALLER
#

if [ $1 -eq '--clear' ];
  then
    echo -e "Uninstalling Hello Bash script";
    echo ''
    echo "Making backup of your '~/.bashrc' in ~/.bashrc.backup ...";
    echo ''
    cp ~/.bashrc ~/.bashrc.backup
    check_command_exec_status $?
    echo ''
    echo "Uninstalling (2 steps) ...";
    head -n $(($BEGIN_LINE-1)) ~/.bashrc.backup > ~/.bashrc
    check_command_exec_status $?

    tail -n $(($TAIL_LINES-1)) ~/.bashrc.backup >> ~/.bashrc
    check_command_exec_status $?

    echo "Sourcing ~/.bashrc"
    source ~/.bashrc
    check_command_exec_status $?
  return
fi;

#
# DIALOG BEFORE INSTALL
#

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
read -p "User name color? (0-6, empty for random): " user_name_color
if [ -z $user_name_color ]; then
  user_name_color=$(random)
fi

user_name='\['${colors[$user_name_color]}'\]'${user_name}'\['${NC}'\]'

#
# HOST
#
read -p "Host Name? (empty for system value): " host_name
if [ -z $host_name ]; then
  host_name='\h';
fi

listColors
read -p "Host name color? (0-6, empty for random): " host_name_color
if [ -z $host_name_color ]; then
  host_name_color=$(random)
fi

host_name='\['${colors[$host_name_color]}'\]@'${host_name}'\['${NC}'\]'

#
# PATH
#
read -p "Do you want your path in PS1 (empty for yes, 'n' for no): " show_path

if [ -z $show_path ]; then
  listColors
  read -p "Host path color? (0-6, empty for random): " host_path_color
  if [ -z $host_path_color ]; then
    host_path_color=$(random)
  fi
  path='\['${colors[$host_path_color]}'\]\W\['${NC}'\]'
else
  path=''
fi

#
# GIT
#
read -p "Do you want git branch and dirty files count? (empty for yes, 'n' for no): " show_git

if [ -z $show_git ]; then
  listColors
  read -p "Git tools color? (0-6, empty for random): " git_color
  if [ -z $git_color ]; then
    git_color=$(random)
  fi

  # SOME FUNCTIONS FOR GIT
  GIT_FUNCTIONS='git_branch (){
      git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/";
    };
    git_changed_files () {
      nocf=$(git status -s 2> /dev/null | wc -l | tr -d " ");
      if [ $nocf -ne 0 ];
        then echo " "$nocf" ";
      fi;};'
  git_tools='\['${colors[$git_color]}'\]\$(git_branch)\$(git_changed_files)\['${NC}'\]'
  # echo 'number_of_changed_files: ' $number_of_changed_files
else
  git_tools=''
fi

PS1=" ${user_name} ${host_name} ${path} ${git_tools} "

SOURCE='PS1="'$PS1'"'

#
#
# INSTALLER
#
#

  # Can't find both GGA markers
  if [[  -z $BEGIN_LINE ]] && [[  -z $END_LINE ]]
  then
    echo ''
    echo -e "Can't find both markers so I add new block for you";
    echo ''
    echo "Making backup of your '~/.bashrc' in ~/.bashrc.backup ...";
    echo ''
    cp ~/.bashrc ~/.bashrc.backup
    check_command_exec_status $?
    echo ''
    echo "Installing (4 steps) ...";

    echo ''>> ~/.bashrc

    echo ${BEGIN}>> ~/.bashrc
    check_command_exec_status $?

    echo "$GIT_FUNCTIONS" >> ~/.bashrc
    check_command_exec_status $?

    echo ${SOURCE} >> ~/.bashrc
    check_command_exec_status $?

    echo ${END}>> ~/.bashrc
    check_command_exec_status $?

    echo ''>> ~/.bashrc
    # . ~/.bashrc

    echo "Sourcing ~/.bashrc"
    source ~/.bashrc
    check_command_exec_status $?
    return
  fi

  # One of markers is broken
  if [[ -z $BEGIN_LINE ]] || [[ -z  $END_LINE ]]
  then
    echo -e "It looks like one of two GGA markers is broken. Hmm.. I guess you'll need to fix it yourself.\n You must check that ${red}${BEGIN}${NC} is placed in the beginning and ${red}${END}${NC}  in the end of Go Git Aliases block.";
    return
  fi

  # All right, found both markers
if [[ $BEGIN_LINE ]] && [[ $END_LINE ]]
then
  echo -e "Found block. Updating...";
  echo ''
  echo "Making backup of your '~/.bashrc' in ~/.bashrc.backup ...";
  echo ''
  cp ~/.bashrc ~/.bashrc.backup
  check_command_exec_status $?
  echo ''
  echo "Installing (4 steps) ...";
  head -n $BEGIN_LINE ~/.bashrc.backup > ~/.bashrc
  check_command_exec_status $?

  echo "$GIT_FUNCTIONS" >> ~/.bashrc
  check_command_exec_status $?

  echo ${SOURCE} >> ~/.bashrc
  check_command_exec_status $?

  tail -n $TAIL_LINES ~/.bashrc.backup >> ~/.bashrc
  check_command_exec_status $?

  echo "Sourcing ~/.bashrc"
  source ~/.bashrc
  check_command_exec_status $?
  return

fi
}
