#!/bin/bash
if [ $# -lt 2 ]
  then
    echo "Please supply the origin and destination volume names. Destination files will be erased."
    echo "Ex. $0 origin_volume destination_volume"
    echo " "
    exit
fi

SOURCE=$1
DESTINATION=$2
# Check if docker volume exists
if  $(docker volume ls -q | grep -q $SOURCE) ; then
    read -p "Volumes exists, overwrite all files on destination? [yn] " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
else
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Copying all files from $SOURCE to $DESTINATION"

docker run -d --rm \
  -v $SOURCE:/source \
  -v $DESTINATION:/dest \
  alpine \
  /bin/sh -c "rm -rf /dest/*; cp -R /source/* /dest/"
