./mkcert -install
./mkcert localhost
service mysql start
service php7.3-fpm start
service nginx start
tail -f /dev/null
