#!/bin/bash

if [ $# -ne 3 ];
then
  echo "Usage: $0 <cm-host:cm-port> <user> <pass>"
  echo "Example: ./$0 localhost:7180 admin admin"
  exit 1
fi

LOG_FILE="$0.log"
CM_URL=http://$1
USER_STRING=$2:$3

API_VERSION=$(curl -X GET -u "$USER_STRING" $CM_URL/api/version 2>>$LOG_FILE)
# echo "Api Version: $API_VERSION"

HOSTS=( $(curl -X GET -u "$USER_STRING" $CM_URL/api/$API_VERSION/hosts 2>>$LOG_FILE \
            | egrep "ipAddress|hostname" \
            | cut -d':' -f2              \
            | cut -d',' -f1              \
            | sed -e 's/"//g'            \
            | sed -e 's/^ *//g'          \
      ) )

x=0
for host in "${HOSTS[@]}";
do
  if [ $x -eq 0 ];
  then
    printf "$host\t"
    x=1
  else
    printf "$host\n"
    x=0
  fi
done
