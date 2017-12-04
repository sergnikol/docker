source inc/container_name.sh
NGINX_LOCAL_DIR="${PWD}/nginx"
PHP_VERSION=`ls ${PWD} | grep -E "^run_[0-9]*(php[0-9]+)." | sed "s/run_[0-9]*\(php[0-9]*\).*/\1/g"`