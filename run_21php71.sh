#!/bin/sh
source inc/init.sh
IMAGE=php:7.1-fpm
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d --name="$CONTAINER" \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
