#!/bin/sh
DB_PATH="$PWD/mysql"
IMAGE="mysql:5.7"
CONTAINER="mysql"
MYSQL_PORT="3306"
MYSQL_ROOT_PASSWORD="testo"
if [ ! -d "$DB_PATH"  ]
then
    mkdir ${DB_PATH}
    echo "$IMAGE" > ${DB_PATH}/README.txt
fi
docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --restart unless-stopped --name=$CONTAINER  -d -p ${MYSQL_PORT}:3306  -v ${DB_PATH}:/var/lib/mysql  ${IMAGE}
