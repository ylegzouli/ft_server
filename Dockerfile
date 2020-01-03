FROM	debian:buster

#  MAJ
RUN apt-get update && apt-get upgrade

#  INSTALL: wget + serveur nginx + mysql
RUN apt-get install -y wget nginx mariadb-server mariadb-client

#  INSTALL: php extensions (fpm et mysql -> mariaDB)
RUN apt-get install -y php php-fpm php-mysql    php-cli php-mbstring  php-gd php-curl php-json




