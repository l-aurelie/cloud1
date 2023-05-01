echo "=> INSTALL NGINX"

sudo apt install -y nginx
sudo ufw app list

sudo ufw allow 'Nginx HTTP'
sudo ufw status
#systemctl status nginx