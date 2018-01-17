#!/bin/sh
. inc/init.sh
IMAGE=php71dev
DOCKERHOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
docker build -t $IMAGE - < Dockerfile_php71dev 
docker stop $CONTAINER
docker rm $CONTAINER
#-p 35729:35729 \
docker run  -d \
            --restart unless-stopped  \
            -e XDEBUG_CONFIG="remote_host=$DOCKERHOST" \
            --name="$CONTAINER" \
            --link=mysql \
            -v ${NGINX_LOCAL_DIR}/sites:/usr/share/nginx \
            -v $PWD/tmp:/root/tmp \
            $IMAGE
