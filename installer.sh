#!/bin/bash

#
#
# Showing command execution status to user
#
#

check_command_exec_status () {
  if [ $1 -eq 0 ]
    then
      echo -e "SUCCESS!"
      echo
      sleep 1
  else
    echo -e "ERROR"
    echo

  fi
}

echo 'Hello, I am HelloBAsh quick installer script'
echo ''
echo 'Making folder ~/.helloBash ...'
echo ''
mkdir ~/.helloBash
check_command_exec_status $?
echo ''
echo 'Putting script in ~/.helloBash ...'
echo ''
curl https://raw.githubusercontent.com/studioflag/helloBash/master/helloBash.sh >> ~/.helloBash/helloBash.sh
check_command_exec_status $?
echo ''
echo -e "Making alias \033[1;35m helloBash \033[0m in your ~/.bashrc ..."
echo ''
echo 'alias helloBash=". ~/.helloBash/helloBash.sh"' >> ~/.bashrc
check_command_exec_status $?
echo ''
echo 'Self-terminating'
echo ''
rm -f ${0##*/}
check_command_exec_status $?
echo ''
echo 'Done! Do not forget to source your ~/.bashrc by typing:'
echo ''
echo  -e "\033[1;35m source ~/.bashrc \033[0m"
