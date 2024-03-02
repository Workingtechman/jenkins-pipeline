#!/bin/bash

ARRAY=$(git diff --name-only ${baseCommit}..${lastCommit} | grep ui-kit/ | cut -f1 -d '/')
if [[ "${ARRAY[0]}" == "ui-kit"  ]]
then
#  echo "ARRAY is ${ARRAY[0]}"
  ARRAY2=("${ARRAY[0]}")
else
# ARRAY=$(git diff --name-only HEAD~1..HEAD | grep apps/ | cut -f2 -d '/')
# echo "baseCommit is ${baseCommit} and lastCommit is ${lastCommit}"
  ARRAY=$(git diff --name-only ${baseCommit}..${lastCommit} | grep apps/ | cut -f2 -d '/')
  ARRAY2=( )
#  echo "list of interesting changed paths:"
#  for i in ${ARRAY[*]}
#  do
#    echo "${i}"
#  done
  for i in ${ARRAY[*]}
  do
    if [[ "${i}" == "cpvb" || "${i}" == "detection" || "${i}" == "intersect" || "${i}" == "main" || "${i}" == "stvb" ]]
    then
  #    echo "first loop and i = ${i}" 
      for x in ${ARRAY2[*]}
      do
  #      echo "second loop. i = ${i}, x = ${x}"
        if [[ "${x}" == "${i}" ]]
        then
  #        echo "${i} already exists in ARRAY2, return to first loop, next value"
  #        echo "========================================"
      continue 2
  #      else
  #        echo "i and x not equal, compare next"
        fi
      done
  #    echo "second loop completed, this is first loop, adding ${i} to ARRAY2"
      ARRAY2+=("$(echo ${i})")
  ##  else
  ##    echo "${i} not needed... skip.."
    fi
  #  echo "=================================="
  done
  
  #  echo "=================================="
  #  echo "=================================="
  #  echo "=================================="
  #echo "list resulting array:"
  #echo "number of arguments of ARRAY2 = ${#ARRAY2[*]}"
  if [[ ${#ARRAY2[*]} -eq 0  ]]
  then
    echo "ARRAY2 is empty"
  else
    for i in ${ARRAY2[*]}
    do
      echo ${i}
    done
  fi
fi

