#!/bin/sh
source inc/init.sh
CONTAINER="mysql"
DB_PATH="$PWD/mysql"
IMAGE="mysql:5.7"
MYSQL_PORT="3306"
MYSQL_ROOT_PASSWORD="testo"
docker stop  $CONTAINER
docker rm  $CONTAINER
if [ ! -d "$DB_PATH"  ]
then
    docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d --name="$CONTAINER" $IMAGE
    #docker exec -it mysql bash
    COUNT="0"
    START_MYSQL="0"
    while [  "$START_MYSQL" == "0" ]
    do
       COUNT=$(( $COUNT + 1 ))
       sleep 1
       START_MYSQL=`docker exec  $CONTAINER sh -c "ps xa | grep -E \"[0-9] mysqld$\" | grep -v grep | wc -l " | sed 's#[\n\r]##g'`
       echo "Wait start mysql ${COUNT}s"
    done
    docker cp -a $CONTAINER:/var/lib/mysql ${DB_PATH}
    echo "$IMAGE" > ${DB_PATH}/README.txt
    docker rm -f mysql
fi
docker run -d \
    --restart unless-stopped  \
    --name=$CONTAINER   \
     -v ${DB_PATH}:/var/lib/mysql  \
     -p ${MYSQL_PORT}:3306  \
        ${IMAGE}

#     -v ${DB_PATH}:/var/lib/mysql  \
#echo "docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --restart unless-stopped --name=$CONTAINER  -d -p ${MYSQL_PORT}:3306  -v ${DB_PATH}:/var/lib/mysql  ${IMAGE}"
