#!/bin/sh
CONTAINER=$1
if [ -z $CONTAINER ]
then
   echo "EMPTY container" >&2
   exit;
fi
docker exec -it $CONTAINER bash
