#!/bin/sh
. inc/init.sh
CONTAINER="mysql"
MYSQL_LOCAL_DIR="$PWD/mysql"
IMAGE="mysql:5.7"
MYSQL_PORT="3306"
MYSQL_ROOT_PASSWORD="testo"
docker stop  $CONTAINER
docker rm  $CONTAINER
if [ ! -d $MYSQL_LOCAL_DIR  ]
then
    #echo -n "Enter mysql ROOT PASSWORD: "
    #read MYSQL_ROOT_PASSWORD
    docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d --name="$CONTAINER" $IMAGE
    #docker exec -it mysql bash
    COUNT="0"
    START_CHECK="0"
    while [  $START_CHECK -le 0 ]
    do
       COUNT=$(( $COUNT + 1 ))
       sleep 1
       START_CHECK=`docker exec  $CONTAINER sh -c "ps xa | grep -E \"[0-9] mysqld$\" | grep -v grep | wc -l " | sed 's#[\n\r]##g'`
       echo "Wait start  ${COUNT}s"
    done
    mkdir ${MYSQL_LOCAL_DIR}
    docker cp -a $CONTAINER:/var/lib/mysql ${MYSQL_LOCAL_DIR}/db
    docker cp -a $CONTAINER:/var/log/mysql ${MYSQL_LOCAL_DIR}/log
    docker cp -a $CONTAINER:/etc/mysql ${MYSQL_LOCAL_DIR}/etc
    echo "$IMAGE" > ${MYSQL_LOCAL_DIR}/README.txt
    docker rm -f mysql
fi
docker run -d \
    --restart unless-stopped  \
    --name=$CONTAINER   \
     -v ${MYSQL_LOCAL_DIR}/db:/var/lib/mysql  \
     -v ${MYSQL_LOCAL_DIR}/log:/var/log/mysql  \
     -v ${MYSQL_LOCAL_DIR}/etc:/etc/mysql  \
     -p ${MYSQL_PORT}:3306  \
        ${IMAGE}

#     -v ${MYSQL_LOCAL_DIR}:/var/lib/mysql  \
#echo "docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --restart unless-stopped --name=$CONTAINER  -d -p ${MYSQL_PORT}:3306  -v ${DB_PATH}:/var/lib/mysql  ${IMAGE}"
