FROM    debian:buster

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get install -y php php-fpm php-mysql php-cli php-mbstring php-gd php-curl php-json
RUN apt-get install -y libnss3-tools
RUN apt-get install -y wget

COPY srcs/default /etc/nginx/sites-enabled/default
COPY srcs/init_sql /init_sql
COPY srcs/php.ini /etc/php/7.3/fpm/php.ini

RUN service mysql start && mysql -uroot -proot mysql < "/init_sql"

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN rm phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.0.1-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html
COPY srcs/config.inc.php var/www/html/phpmyadmin/config.inc.php

RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz
RUN tar -xzvf latest-fr_FR.tar.gz
RUN rm latest-fr_FR.tar.gz
RUN mv wordpress /var/www/html
COPY srcs/wp-config.php var/www/html/wordpress/wp-config.php

RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64
RUN mv mkcert-v1.1.2-linux-amd64 mkcert
RUN chmod +x mkcert
EXPOSE 80 443

RUN chown -R www-data:www-data /var/www/html/phpmyadmin
RUN chmod -R 755 /var/www/html/phpmyadmin
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

RUN rm /var/www/html/index.nginx-debian.html
COPY srcs/start.sh /start.sh

CMD ["bash", "/start.sh"]
