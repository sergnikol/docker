cd [dir for copy base mysql]

mysql57 DEFAULT root PASSWORD: testo

phpmyadmin http://localhost:8080

START ALL SCRIPTS
```sh
./start_all_run.sh
```

ADD VIRTUAL HOST
```sh
./virtual.sh [HOSTNAME] [VERSION PHP] [addhosts]  
[addhosts] - optional param add /etc/hosts 127.0.0.1 [HOSTNAME]
```
