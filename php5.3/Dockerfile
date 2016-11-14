FROM rubberboy/centos-apache:2.4.23
MAINTAINER rubberBoy <gaosheng08@gmail.com>

ENV PHP_VERSION 5.3.29
ENV XDEBUG_VERSION 2.2.7

COPY software/php-$PHP_VERSION.tar.gz /opt/php-$PHP_VERSION.tar.gz
COPY software/xdebug-$XDEBUG_VERSION.tgz /opt/xdebug-$XDEBUG_VERSION.tgz
COPY php.conf /usr/local/apache/conf/php.conf

# php5.3
RUN cd /opt/ \
	&& tar -xzvf php-$PHP_VERSION.tar.gz \
	&& cd php-$PHP_VERSION \
	# 解决 「error: Cannot find libmysqlclient_r under /usr」
	&& ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib/ \
	# 解决 「error: Cannot find libmysqlclient_r under /usr」
	&& ln -s /usr/lib64/mysql/libmysqlclient_r.so /usr/lib/ \
	&& ./configure --prefix=/usr/local/php \
		--with-apxs2=/usr/local/apache/bin/apxs \
		--with-mysql --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
	&& make \
	&& make install \
	&& cp /opt/php-$PHP_VERSION/php.ini-development /usr/local/php/php.ini \
	&& cd ../ \
	&& rm -rf php-$PHP_VERSION*

# apache 中 php 配置
RUN echo "Include /usr/local/apache/conf/php.conf" >> /usr/local/apache/conf/httpd.conf

# xdebug
RUN cd /opt/ \
	&& tar -xzvf xdebug-$XDEBUG_VERSION.tgz \
	&& cd xdebug-$XDEBUG_VERSION \
	&& /usr/local/php/bin/phpize \
	&& ./configure --with-php-config=/usr/local/php/bin/php-config \
	&& make \
	&& make install \
	&& cd ../ \
	&& rm -rf xdebug-$XDEBUG_VERSION* \
	&& echo "[xdebug]" >> /usr/local/php/lib/php.ini \
	&& echo "zend_extension=/usr/local/php/lib/php/extensions/no-debug-zts-20131226/xdebug.so" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.remote_enable=on" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.remote_port=9000" >> /usr/local/php/lib/php.ini \
	&& echo ";xdebug.remote_connect_back=on" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.remote_handler=dbgp" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.remote_host=192.168.1.103" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.remote_autostart=on" >> /usr/local/php/lib/php.ini \
	&& echo "xdebug.idekey=PhpStorm" >> /usr/local/php/lib/php.ini

EXPOSE 22 80 9000


