echo "=> INSTALL NGINX"

DOMAIN_NAME=myhomeserver
PHP_SERV_IP=192.168.1.34

sudo apt install -y nginx
sudo ufw app list

sudo ufw allow 'Nginx HTTP'
sudo ufw status
#systemctl status nginx

# This part has to be on php server were will be the site? 
# --Create site directory root where to put sites pages
# echo "-> Create site root dir"
# sudo mkdir /var/www/$DOMAIN_NAME
# sudo chown -R $USER:$USER /var/www/$DOMAIN_NAME

# # --Create a index.html to test, instead use ftp to download all your page in /var/www/$DOMAIN_NAME
# cat > /var/www/$DOMAIN_NAME/index.html <<EOF
# <html><p>bonjour les amis</p></html>
# EOF
# cat > /var/www/$DOMAIN_NAME/index.php <<EOF
# <?php
# phpinfo();
# ?>
# EOF

# --Dynamically create server conf file
# /!\Be carefull if you need var like nginx's one, they will be interpreted, use another way than heredoc (if has bugs check your config file is has you want in /etc/nginx/sites-available)
echo "-> Create server conf for $DOMAIN_NAME"
sudo touch  /etc/nginx/sites-available/$DOMAIN_NAME
sudo chown -R $USER:$USER /etc/nginx/sites-available/$DOMAIN_NAME
cat > /etc/nginx/sites-available/$DOMAIN_NAME <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN_NAME;

    root /var/www/$DOMAIN_NAME;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi.conf;
        fastcgi_pass $PHP_SERV_IP:9000;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
# I added those in location blocs to have debug message or var : access it in response header
#add_header X-debug-message "A php file was used" always;
#add_header X-debug-document-root "$document_root" always;

echo "-> Enable site http://$DOMAIN_NAME"
sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/$DOMAIN_NAME
echo "-> Testing conf syntax:"
sudo nginx -t
echo "-> Reload nginx"
sudo systemctl reload nginx