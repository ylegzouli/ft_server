FROM	debian:buster

#  MAJ
RUN apt-get update && apt-get upgrade

#  INSTALL: wget + serveur nginx + mysql
#  INSTALL: unzip pour decompresser + ca-certificates??? + libssl1.1???
RUN apt-get install -y wget nginx mariadb-server mariadb-client
RUN apt-get install unzip 
#  ca-certificates libssl1.1

#  INSTALL: php extensions (VOIR extention necessaire ???)
RUN apt-get install -y php php-fpm php-mysql php-cli php-mbstring php-gd php-curl php-json

#  COPY: fichier de configuration nginx
#COPY nginx.conf /etc/nginx/nginx.conf

#  COPY: script a executer au demarage
#  RUN: lancer une commande, ici application des droits d'execution
COPY srcs/start.sh /home/docker/script/start.sh
RUN chmod 744 /home/docker/script/start.sh

#  COPY: archive wordpress + archive phpmyadmin   ?????
COPY srcs/wordpress /etc/nginx/sites-available/
COPY srcs/phpmyadmin /etc/nginx/sites-available/

#  Remplacement du fichier default??? de nginx
#  Supression du fichier d'index nginx
RUN rm /etc/nginx/sites-available/default
COPY srcs/default /etc/nginx/sites-available/default
RUN rm /var/www/html/index.nginx-debian.html

#  Remplacement du fichier php.ini???
RUN rm /etc/php/7.3/fpm/php.ini
COPY srcs/php.ini /etc/php/7.3/fpm/php.ini

#  Telechargement, decompression, deplacement des fichier puis supression archive wordpress
#  Application des droits
#  COPY du fichier de config wordpress
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz
RUN tar -xzvf latest-fr_FR.tar.gz
RUN mv wordpress /var/www/html
RUN rm latest-fr_FR.tar.gz
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/
COPY srcs/wp-config.php /var/www/html/wordpress

#  Telechargement, decompression, deplacement des fichier puis supression archive phpMyAdmin
#  Application des droits
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip
RUN unzip phpMyAdmin-4.9.0.1-all-languages.zip 
RUN mv phpMyAdmin-4.9.0.1-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html
RUN rm phpMyAdmin-4.9.0.1-all-languages.zip
RUN chown -R www-data:www-data /var/www/html/phpmyadmin
RUN chmod -R 755 /var/www/html/phpmyadmin

#  Parametrage des options de connexion mysql via le fichier init.sql
COPY srcs/init.sql /
RUN service mysql start && mysql -uroot -proot mysql < "/init.sql"

#  Gestion du certificat ssl ???
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048\
    -subj '/C=FR/ST=75/L=Paris/O=42/CN=avan-pra'\
    -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

#  Exposition des ports
EXPOSE 80 443

#  Lancement
CMD ["bash", "/utils/init.sh"]


