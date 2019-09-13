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

SCRIPTS_FOLDER=~/.gg_tools
SCRIPT_NAME='HelloBashGeneratedPrompt'

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
  else
    echo -e "${red}ERROR${NC}"
    echo

  fi
}

function helloBash () {



  #
  # UNINSTALLER
  #

  if [[ $1 = "--clear" ]];
    then
      echo -e "Removing ${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh"
      rm -f ${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh
      check_command_exec_status $?

      echo -e "Sourcing your ~/.bashrc"
      source ~/.bashrc
      check_command_exec_status $?
    return
  fi;


#
# DIALOG BEFORE INSTALL
#

colors=($black $red $yellow $blue $purple $cyan $white $green)

function listColors () {
  for index in ${!colors[*]}
  do
      echo -e ${colors[$index]} $index $NC
  done
}
function random () {
  echo $(( ( RANDOM % 8 )  + 0 ))
}

echo "Hello! This is PS1 installer!"

#
# NAME
#
read -p "User name? (enter value or type 'system' for system value): " user_name
if [[ $user_name == "system" ]]; then
    user_name='\u';
fi

if [[ $user_name != '' ]]; then
  listColors
  read -p "User name color? (0-7, empty for random): " user_name_color
  if [ -z $user_name_color ]; then
    user_name_color=$(random)
  fi

  user_name='\['${colors[$user_name_color]}'\]'${user_name}'\['${NC}'\]'
fi

#
# HOST
#
read -p "Host Name? (enter value or type 'system' for system value): " host_name
if [[ $host_name == "system" ]]; then
    host_name='\h';
fi

if [[ $host_name != '' ]]; then
  listColors
  read -p "Host name color? (0-7, empty for random): " host_name_color
  if [ -z $host_name_color ]; then
    host_name_color=$(random)
  fi

  host_name='\['${colors[$host_name_color]}'\]@'${host_name}'\['${NC}'\]'
fi

#
# PATH
#
read -p "Do you want your path in PS1 (empty for full path, 'short' for short path, 'n' for no): " show_path

if [ -z $show_path ] || [ $show_path = 'short' ] ; then
#  Choose color
  listColors
  read -p "Host path color? (0-7, empty for random): " host_path_color
  if [ -z $host_path_color ]; then
    host_path_color=$(random)
  fi

  if [ -z $show_path ]; then
#  Full path
    path='\['${colors[$host_path_color]}'\]\w\['${NC}'\]'
    else
#   Short path
    path='\['${colors[$host_path_color]}'\]\W\['${NC}'\]'
  fi
else
  path=''
fi

#
# GIT
#
read -p "Do you want git branch and dirty files count? (empty for yes, 'n' for no): " show_git

if [ -z $show_git ]; then
  listColors
  read -p "Git tools color? (0-7, empty for random): " git_color
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

# creating scripts directory if doesn't exists

if [ ! -d  $SCRIPTS_FOLDER ]; then
  echo -e "Making ${white}${SCRIPTS_FOLDER}${NC} directory for any Go Git Script"
  mkdir $SCRIPTS_FOLDER
  check_command_exec_status $?
  else
  echo -e "Found ${white}${SCRIPTS_FOLDER}${NC} folder. Continuing ..."
fi

echo -e "Putting Git funstions in ${white}${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh${NC} folder"
echo "$GIT_FUNCTIONS" >> ${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh
check_command_exec_status $?

echo -e "Putting new prompt in ${white}${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh${NC} folder"
echo "${SOURCE}" >> ${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh
check_command_exec_status $?

echo -e "Sourcing new prompt"
source ${SCRIPTS_FOLDER}/${SCRIPT_NAME}.sh
check_command_exec_status $?
}
