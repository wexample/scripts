#!/usr/bin/env bash

renderProgressBarArgs() {
  _ARGUMENTS=(
    [0]='percentage p "Percentage" true'
    [1]='width w "Width" true'
    [2]='description d "Description" false'
    [3]='status s "Status" false'
    [4]='new_line nl "New line at end" false'
  )
}

renderProgressBar() {
  local MESSAGE='['
  local PRECISION=100;

  if [ "${DESCRIPTION}" != "" ];then
    MESSAGE=${DESCRIPTION}"\n"${MESSAGE}
  fi

  if [ "${WIDTH}" == "" ];then
    WIDTH=30
  fi

  for ((i=0;i<=${WIDTH};i++));
  do
     I_CALC=$(expr ${i} \* ${PRECISION})
     I_CALC=$(expr ${I_CALC} / ${WIDTH})
     I_CALC=$(expr ${I_CALC} \* 100)
     I_CALC=$(expr ${I_CALC} / ${PRECISION})

     if [ ${I_CALC} -lt ${PERCENTAGE} ] || [ ${I_CALC} == ${PERCENTAGE} ];then
       MESSAGE+='#'
     else
       MESSAGE+='.'
     fi
  done

  MESSAGE+="] ("${PERCENTAGE}'%)'

  if [ "${STATUS}" != "" ];then
    MESSAGE+=" > "${STATUS}
  fi

  if [ "${NEW_LINE}" == "true" ];then
    echo ${MESSAGE}'       '
  else
    echo -ne ${MESSAGE}'       \r'
  fi
}
