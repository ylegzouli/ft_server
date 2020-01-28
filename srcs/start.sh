# Demarage des different service
service nginx start
service mysql restart
service php7.3-fpm start
# suivi du fichier null (affichage derniere ligne puis toutes les ligne afficher a la suite)
tail -f /dev/null
