#!/bin/sh
source inc/init.sh
docker build -t php56 - < Dockerfile_php56
IMAGE=php56
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d \
        --restart unless-stopped  \
        --name="$CONTAINER" \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
