#!/bin/sh
docker stop phpmyadmin
docker rm phpmyadmin
docker run -p 8080:80 --name phpmyadmin --restart unless-stopped -d --link mysql:db phpmyadmin/phpmyadmin
