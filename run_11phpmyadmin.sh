#!/bin/sh
docker stop phpmyadmin
docker rm phpmyadmin
docker run -d \
           -p 8080:80 \
          --name phpmyadmin \
       --restart unless-stopped \
       --link mysql:db \
       phpmyadmin/phpmyadmin
