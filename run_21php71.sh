#!/bin/sh
source inc/init.sh
docker build -t php71 - < Dockerfile_php71
IMAGE=php71
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d \
            --restart unless-stopped  \
            --name="$CONTAINER" \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
