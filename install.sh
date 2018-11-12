#!/bin/bash

yum install epel-release yum-utils -y
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72

yum -y install httpd libmcrypt-dev php libapache2-mod-php \
    php-mysql mod_ssl mod_php mod_rewrite openssl wget unzip

cd /tmp && \
    wget -c https://wordpress.org/wordpress-4.9.8.tar.gz && \
    tar -xzvf wordpress-4.9.8.tar.gz && \
    rm wordpress-4.9.8.tar.gz && \
    rm -Rf /var/www/html/* && \
    mv wordpress/* /var/www/html/ 

cd /tmp && \
    wget https://downloads.wordpress.org/plugin/wordpress-social-login.zip && \
    unzip wordpress-social-login.zip && \
    rm wordpress-social-login.zip && \
    mv wordpress-social-login /var/www/html/wp-content/plugins/

cp wp-config.php /var/www/html/    

cp servername.conf /etc/httpd/conf.d/

sed -i "s|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|SSLCertificateFile /etc/pki/tls/certs/server.crt|g" /etc/httpd/conf.d/ssl.conf && \
sed -i "s|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|SSLCertificateKeyFile /etc/pki/tls/private/server.key|g" /etc/httpd/conf.d/ssl.conf
