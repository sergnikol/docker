#!/bin/sh
# "generated" vhost
. inc/init.sh
HOST=$1;
PHP=$2
if [ -z $HOST ]
then
   echo "EMPTY host" >&2
   echo "example: $0 (HOST) (`echo $PHP_VERSION`) [addhost - optional for add /etc/hosts]"
   exit;
 fi
 if [ -z $PHP ]
then
   echo "EMPTY version php" >&2
   echo "example: $0 $1 (`echo $PHP_VERSION`) [addhost - optional for add /etc/hosts]"
   exit;
fi
VALID=$(echo "$PHP_VERSION" | grep -E "^$PHP$" | wc -l | awk '{print $1}')
if [ "$VALID" = "0" ]; then
     echo "NOT VALID VERSION PHP"
     echo "example: $0 $1 (`echo $PHP_VERSION`)" 
     exit
 fi
SITES=$HOST/public
DOC_ROOT=/usr/share/nginx/$SITES
DOC_ROOT_LOCAL=$PWD/nginx/sites/$SITES
PATH_CONF=${PWD}/nginx/conf.d/${HOST}.conf
mkdir -p ${DOC_ROOT_LOCAL}
if [ ! -f $DOC_ROOT_LOCAL/index.php ]; 
then
    #echo "<?php phpinfo();" > $DOC_ROOT_LOCAL/index.php
    cp inc/start_page.php $DOC_ROOT_LOCAL/index.php
fi


STR=`grep -E "\s${HOST}$" /etc/hosts | wc -l | awk '{print $1}'`;
if [ "$STR" = "0" ] && [ "$3" = "addhost" ]; then 
    echo "for automatic add ${HOST} to /etc/hosts use root password"
    sudo sh -c "echo \"127.0.0.1\t$HOST\">> /etc/hosts"
fi
     

cat << EOF > $PATH_CONF
server {
    listen 80;
    server_name $HOST;
    root $DOC_ROOT;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    error_log  /var/log/nginx/${HOST}_error.log;
    access_log /var/log/nginx/${HOST}_access.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass $PHP:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF
docker restart nginx
