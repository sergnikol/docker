#!/bin/sh
. inc/init.sh
IMAGE=php56
docker build -t $IMAGE - < Dockerfile_php56
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d \
        --restart unless-stopped  \
        --name="$CONTAINER" \
        --link=mysql \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
