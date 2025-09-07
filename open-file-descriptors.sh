#!/bin/bash
# open-file-count.sh
# Count open file descriptors for a given user (-u) or process (-p)

usage() {
  echo "Usage: $0 -u <username> | -p <pid>"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

while getopts ":u:p:" opt; do
  case $opt in
    u)
      USER=$OPTARG
      COUNT=$(lsof -u "$USER" 2>/dev/null | wc -l)
      echo "User '$USER' is using $COUNT file descriptors"
      ;;
    p)
      PID=$OPTARG
      if [ ! -d "/proc/$PID" ]; then
        echo "Error: Process $PID not found"
        exit 1
      fi
      COUNT=$(ls /proc/$PID/fd 2>/dev/null | wc -l)
      LIMIT=$(grep "open files" /proc/$PID/limits 2>/dev/null)
      echo "Process $PID is using $COUNT file descriptors"
      echo "Limits: $LIMIT"
      ;;
    \?)
      usage
      ;;
  esac
done
