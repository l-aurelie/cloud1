echo "=> PHP SERVER"

MYSQL_SERV_IP=192.168.1.35
NGINX_SERV_IP=192.168.1.33
DOMAIN_NAME=myhomeserver

sudo apt update
sudo apt install -y php-fpm php-mysql

#sudo apt install -y mariadb-client
#mysql -u user -h $MYSQL_SERV_IP -p

# --Create site directory root where to put sites pages
echo "-> Create site root dir"
sudo mkdir /var/www
sudo mkdir /var/www/$DOMAIN_NAME
sudo chown -R $USER:$USER /var/www/$DOMAIN_NAME

# --Create a index.html to test, instead use ftp to download all your page in /var/www/$DOMAIN_NAME
cat > /var/www/$DOMAIN_NAME/index.html <<EOF
<html><p>bonjour les amis</p></html>
EOF
cat > /var/www/$DOMAIN_NAME/index.php <<EOF
<?php
phpinfo();
?>
EOF

php_version=$(echo `php -v` | awk '/^PHP/ {print $2}' | cut -f1,2 -d'.')
sudo sed -i 's/^listen =.*/listen = 0.0.0.0:9000/' /etc/php/$php_version/fpm/pool.d/www.conf
sudo sed -i "s/^;\?listen.allowed_clients =.*/listen.allowed_clients = 127.0.0.1,$NGINX_SERV_IP/" /etc/php/$php_version/fpm/pool.d/www.conf
#A verifier pas une bonne idee ?
#sudo sed -i 's/\(security.limit_extensions = .*\)/\1 .html/' /etc/php/8.1/fpm/pool.d/www.conf

sudo systemctl reload "php$php_version-fpm"