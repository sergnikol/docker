#!/bin/sh
. inc/init.sh
IMAGE=php71
docker build -t $IMAGE - < Dockerfile_php71
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d \
            --restart unless-stopped  \
            --name="$CONTAINER" \
            --link=mysql \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
