cd [dir for copy base mysql]

mysql57 DEFAULT root PASSWORD: testo
```sh
wget https://raw.githubusercontent.com/sergnikol/docker/master/start_mysql_5.7.sh
chmod +x start_mysql_5.7.sh
./start_mysql_5.7.sh
```

phpmyadmin http://localhost:8080
```sh
wget -q -O - https://raw.githubusercontent.com/sergnikol/docker/master/start_phpmyadmin.sh | sh -
```
