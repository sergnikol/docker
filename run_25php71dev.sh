#!/bin/sh
. inc/init.sh
IMAGE=php71dev
docker build -t $IMAGE - < Dockerfile_php71dev 
docker stop $CONTAINER
docker rm $CONTAINER
docker run  -d \
            --restart unless-stopped  \
            -p 9001:9001 \
            -e PHP_XDEBUG_ENABLED=1 \
            -e XDEBUG_CONFIG="idekey=netbeans-xdebug" \
            -e PHP_IDE_CONFIG="serverName=blog" \
            --name="$CONTAINER" \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
             $IMAGE
