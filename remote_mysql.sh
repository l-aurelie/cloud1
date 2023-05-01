echo "=> PHP SERVER"

MYSQL_SERV_IP=192.168.1.28

#sudo apt update
sudo apt install -y mariadb-client
mysql -u user -h $MYSQL_SERV_IP -p
