#!/bin/bash
# check_fd_count.sh
# Count open file descriptors for a given user or process

if [ -z "$1" ]; then
  echo "Usage: $0 <user|pid>"
  exit 1
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
  # If input is a PID
  PID=$1
  COUNT=$(ls -l /proc/$PID/fd 2>/dev/null | wc -l)
  LIMIT=$(grep "open files" /proc/$PID/limits 2>/dev/null)
  echo "Process $PID is using $COUNT file descriptors"
  echo "Limits: $LIMIT"
else
  # If input is a username
  USER=$1
  COUNT=$(lsof -u $USER 2>/dev/null | wc -l)
  echo "User $USER is using $COUNT file descriptors"
fi
