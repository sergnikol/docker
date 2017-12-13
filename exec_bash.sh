#!/bin/sh
CONTAINER=$1
if [ -z $CONTAINER ]
then
   CONTAINER="php71dev"
   echo "EMPTY container set default $CONTAINER" >&2
   #exit;
fi
docker exec -it $CONTAINER bash
