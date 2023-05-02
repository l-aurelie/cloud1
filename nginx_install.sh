echo "=> INSTALL NGINX"

DOMAIN_NAME=myhomeserver

#sudo apt install -y nginx
sudo ufw app list

sudo ufw allow 'Nginx HTTP'
sudo ufw status
#systemctl status nginx

# --Create site directory root where to put sites pages
echo "-> Create site root dir"
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

# --Dynamically create server conf file
echo "-> Create server conf for $DOMAIN_NAME"
sudo touch  /etc/nginx/sites-available/$DOMAIN_NAME
sudo chown -R $USER:$USER /etc/nginx/sites-available/$DOMAIN_NAME
cat > /etc/nginx/sites-available/$DOMAIN_NAME <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN_NAME;

    root /var/www/$DOMAIN_NAME;
    index index.html index.htm index.php;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

echo "-> Enable site http://$DOMAIN_NAME"
sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/$DOMAIN_NAME
echo "-> Testing conf syntax:"
sudo nginx -t
echo "-> Reload nginx"
sudo systemctl reload nginx