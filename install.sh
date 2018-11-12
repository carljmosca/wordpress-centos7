#!/bin/bash

LOG_LOCATION="/var/log"
INSTALL_SOURCE=$(pwd)
exec > >(tee -ai $LOG_LOCATION/wordpress-instal.log)
exec 2>&1
echo "Installing from $INSTALL_SOURCE and logging to $LOG_LOCATION/wordpress-install.log"

sudo yum install wget epel-release yum-utils -y
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72

sudo yum -y install httpd libmcrypt-dev php libapache2-mod-php \
    php-mysql mod_ssl mod_php mod_rewrite openssl wget unzip

cd /tmp && \
    sudo wget -c https://wordpress.org/wordpress-4.9.8.tar.gz && \
    sudo tar -xzvf wordpress-4.9.8.tar.gz && \
    sudo rm wordpress-4.9.8.tar.gz && \
    sudo rm -Rf /var/www/html/* && \
    sudo mv wordpress/* /var/www/html/ 

cd /tmp && \
    sudo wget https://downloads.wordpress.org/plugin/wordpress-social-login.zip && \
    sudo unzip wordpress-social-login.zip && \
    sudo rm wordpress-social-login.zip && \
    sudo mv wordpress-social-login /var/www/html/wp-content/plugins/

sudo cp $INSTALL_SOURCE/wp-config.php /var/www/html/    

sudo cp $INSTALL_SOURCE/servername.conf /etc/httpd/conf.d/

#sudo sed -i "s|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|SSLCertificateFile /etc/pki/tls/certs/server.crt|g" /etc/httpd/conf.d/ssl.conf && \
#sudo sed -i "s|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|SSLCertificateKeyFile /etc/pki/tls/private/server.key|g" /etc/httpd/conf.d/ssl.conf
