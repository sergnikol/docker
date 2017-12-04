#!/bin/sh
# "generated" vhost
source inc/init.sh
HOST=$1;
PHP=$2
if [ -z $HOST ]
then
   echo "EMPTY host" >&2
   echo "example: $0 (HOST)"
   exit;
 fi
 if [ -z $PHP ]
then
   echo "EMPTY version php" >&2
   echo "example: $0 $1 (`echo $PHP_VERSION`)"
   exit;
fi
VALID=$(echo "$PHP_VERSION" | grep -E "^$PHP$" | wc -l | awk '{print $1}')
if [ "$VALID" == "0" ]
then
     echo "NOT VALID VERSION PHP"
     echo "example: $0 $1 (`echo $PHP_VERSION`)" 
     exit
 fi
 exit
SITES=$HOST/public
DOC_ROOT=/usr/share/nginx/$SITES
DOC_ROOT_LOCAL=$PWD/nginx/sites/$SITES
PATH_CONF=${PWD}/nginx/etc/conf.d/virtual_${HOST}.conf
mkdir -p ${DOC_ROOT_LOCAL}
if [ ! -f $DOC_ROOT_LOCAL/index.php ]; 
then
    echo "<?php phpinfo();" > $DOC_ROOT_LOCAL/index.php
fi

STR=`grep -E "\s${HOST}$" /etc/hosts`;
if [ -z "$STR" ]; then
    echo "for automatic add ${HOST} to /etc/hosts use root password"
    sudo sh -c "echo \"127.0.0.1\t$HOST\">> /etc/hosts"
fi
     

cat << EOF > $PATH_CONF
server {
    listen 80;
    server_name $HOST;
    root $DOC_ROOT;
    index index.php index.html;
    error_log  /var/log/nginx/error_$HOST.log;
    access_log /var/log/nginx/access_$HOST.log;
    

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass $PHP:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF
docker restart nginx
