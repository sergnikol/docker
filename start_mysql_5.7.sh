#!/bin/sh
DB_PATH="$PWD/mysql"
IMAGE="mysql:5.7"
CONTAINER="mysql"
MYSQL_PORT="3306"
MYSQL_ROOT_PASSWORD="testo"
if [ ! -d "$DB_PATH"  ]
then
    docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d --name="$CONTAINER" $IMAGE
    COUNT="0"
    START_MYSQL="1"
    while [  "$START_MYSQL" == "1" ]
    do
       COUNT=$(( $COUNT + 1 ))
       sleep 1
       START_MYSQL=`docker exec -it $CONTAINER sh -c "ps xa | grep initialize-insecure | grep -v grep | wc -l" | sed 's#[\n\r]##g'`
       echo "Wait start mysql ${COUNT}s"
    done
    docker cp -a $CONTAINER:/var/lib/mysql ${DB_PATH}
    docker stop mysql
    docker rm mysql
fi
docker run --restart unless-stopped --name=$CONTAINER  -d -p ${MYSQL_PORT}:3306  -v ${DB_PATH}:/var/lib/mysql  ${IMAGE}
