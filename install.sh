#!/bin/bash

LOG_LOCATION="/var/log"
INSTALL_SOURCE=$(pwd)
exec > >(tee -i $LOG_LOCATION/wordpress-instal.log)
exec 2>&1
echo "Log file wordpress-install.log written to [ $LOG_LOCATION ]"

sudo yum install wget epel-release yum-utils -y
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72

sudo yum -y install httpd libmcrypt-dev php libapache2-mod-php \
    php-mysql mod_ssl mod_php mod_rewrite openssl wget unzip

sudo cd /tmp && \
    wget -c https://wordpress.org/wordpress-4.9.8.tar.gz && \
    tar -xzvf wordpress-4.9.8.tar.gz && \
    rm wordpress-4.9.8.tar.gz && \
    rm -Rf /var/www/html/* && \
    mv wordpress/* /var/www/html/ 

sudo cd /tmp && \
    wget https://downloads.wordpress.org/plugin/wordpress-social-login.zip && \
    unzip wordpress-social-login.zip && \
    rm wordpress-social-login.zip && \
    mv wordpress-social-login /var/www/html/wp-content/plugins/

sudo cp $INSTALL_SOURCE/wp-config.php /var/www/html/    

sudo cp $INSTALL_SOURCE/servername.conf /etc/httpd/conf.d/

sudo sed -i "s|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|SSLCertificateFile /etc/pki/tls/certs/server.crt|g" /etc/httpd/conf.d/ssl.conf && \
sudo sed -i "s|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|SSLCertificateKeyFile /etc/pki/tls/private/server.key|g" /etc/httpd/conf.d/ssl.conf
