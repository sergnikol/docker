#!/bin/sh
. inc/init.sh
IMAGE="nginx"
docker stop $CONTAINER
docker rm $CONTAINER
if [ ! -d $NGINX_LOCAL_DIR  ]; then
    mkdir $NGINX_LOCAL_DIR
    docker run --name="$CONTAINER"  -d -p 80:80 $IMAGE
    docker cp  $CONTAINER:/etc/nginx ${NGINX_LOCAL_DIR}/etc
    docker cp  $CONTAINER:/var/log/nginx ${NGINX_LOCAL_DIR}/log
    docker cp  $CONTAINER:/usr/share/nginx ${NGINX_LOCAL_DIR}/sites
    docker stop $CONTAINER
    docker rm $CONTAINER
fi
docker run -it -d \
           --restart unless-stopped \
           -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
           -v ${NGINX_LOCAL_DIR}/etc:/etc/nginx \
           -v ${NGINX_LOCAL_DIR}/log:/var/log/nginx \
           --link=php56 \
           --link=php71 \
           --name="$CONTAINER" \
            -p 80:80 $IMAGE

