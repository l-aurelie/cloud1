
echo "=> INSTALL AND CONFIG MYSQL"

DB_NAME="wp"
DB_USER="user"

sudo apt purge --auto-remove mariadb-server
sudo apt update
sudo apt install  -y mariadb-server mariadb-client

#php-fpm php-mysql

# include file with secrets
source secret.sh

# SECURE INSTALLATION
# mysql secure installation contains important steps to secure prod projects
# but  is interactive so need to automate with use of a heredoc
# set root pswd, delete anonymous users, no distant connection for root,  delete test db
# set a password for root is an additionnal security, the password wont be used in most case as connection is set to unix_socket no native_password
  #UPDATE mysql.user SET Password=PASSWORD('${DB_ROOT_PSWD}') WHERE User='root';
echo "=> Secure installation"
sudo mysql --user=root <<EOF
  SET PASSWORD FOR 'root'@'localhost' = PASSWORD('DB_ROOT_PSWD');
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test%';
  FLUSH PRIVILEGES;
EOF

# For security purpose do other user than root for db gestion
# As remote access is needed : or add ips that need access as host to the db_user, if unknown add % instead(means all addresses in sql syntax)
# host % would means you can access this database server from any host, this is a risk
echo "=> Create user and db"
sudo mysql --user=root <<EOF
  CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_WP_PSWD}';
  GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';
  FLUSH PRIVILEGES;
EOF

# Allow external connection with 0.0.0.0 instead of 127.0.0.1 and disable skip networking
# If only local access to db, set 127.0.0.1 for security purpose
# bind address means the networks interfaces from which you allow connections, can list only the authorized interfaces separate by ',' (if only 127.0.0.1 : only loopback interface so no remote connection possible), if 0.0.0.0 all interface allowed (list interface with ip a)
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo sed -i "s|.*skip-networking.*|skip-networking = false|g" /etc/mysql/mariadb.conf.d/50-server.cnf 
echo "=> Updated mysql bind address 0.0.0.0 and skip-networking=false to allow external connections."

sudo systemctl restart mysql #always restart for conf to be apply

echo "=> Mysql bind address: " `sudo mysql -b -e "SHOW GLOBAL VARIABLES like 'bind_address'"`
echo " port: " `sudo mysql -b -e "SHOW VARIABLES WHERE Variable_name = 'port';"` 


#echo "=> Verify Nginx is allowed by firewall:"
#sudo ufw app list
#will be on a different host

echo "=> Variable debug : "
echo  $DB_ROOT_PSWD
echo  $DB_USER
echo  $DB_WP_PSWD
echo  $DB_NAME
echo "end"
