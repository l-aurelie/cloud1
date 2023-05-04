echo "=> PHP SERVER"

MYSQL_SERV_IP=192.168.1.28
DOMAIN_NAME=myhomeserver

#sudo apt update
#sudo apt install -y php-fpm php-mysql

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

sudo sed -i 's/^listen =.*/listen = 0.0.0.0:9000/' /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i 's/^;\?listen.allowed_clients =.*/listen.allowed_clients = 127.0.0.1,192.168.1.29/' /etc/php/8.1/fpm/pool.d/www.conf
#A verifier pas une bonne idee ?
#sudo sed -i 's/\(security.limit_extensions = .*\)/\1 .html/' /etc/php/8.1/fpm/pool.d/www.conf

sudo systemctl reload php8.1-fpm