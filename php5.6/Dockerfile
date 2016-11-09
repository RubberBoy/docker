FROM rubberboy/centos-apache:2.4.23
MAINTAINER rubberBoy <gaosheng08@gmail.com>

ENV PHP_VERSION 5.6.27

# php5.3
tar -xzvf php-$PHP_VERSION.tar.gz
cd php-$PHP_VERSION
# 解决 「error: Cannot find libmysqlclient_r under /usr」
ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib/
# 解决 「error: Cannot find libmysqlclient_r under /usr」
ln -s /usr/lib64/mysql/libmysqlclient_r.so /usr/lib/
./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2.4.23/bin/apxs --with-mysql --with-pdo-mysql
make && make install
cp /opt/software/php-5.3.29/php.ini-development /usr/local/php/php.ini

# apache 中 php 配置
vi /usr/local/apache2.4.23/conf/httpd.conf
<IfModule php5_module>
    AddType application/x-httpd-php .php
    AddType application/x-httpd-php-source .phps

    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>
</IfModule>

# xdebug
wget https://xdebug.org/files/xdebug-2.4.1.tgz
wget https://xdebug.org/files/xdebug-2.2.7.tgz
tar -xzvf xdebug-2.2.7.tgz
cd xdebug-2.2.7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install

EXPOSE 22 80 9000

EXPOSE 80
