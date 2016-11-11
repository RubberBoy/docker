FROM centos:6.6
MAINTAINER rubberBoy <gaosheng08@gmail.com>

RUN yum install passwd openssl openssh-server -y \
	&& yum clean all

RUN ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key \
        && ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key \
        && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" \
        && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

ENV APR_VERSION 1.5.2
ENV APR_UTIL_VERSION 1.5.4
ENV PCRE_VERSION 8.39
ENV APACHE_VERSION 2.4.23
ENV PHP_VERSION 5.3.29
ENV XDEBUG_VERSION 2.2.7

COPY apache/software/httpd-$APACHE_VERSION.tar.gz /opt/httpd-$APACHE_VERSION.tar.gz
COPY apache/software/apr-util-$APR_UTIL_VERSION.tar.gz /opt/apr-util-$APR_UTIL_VERSION.tar.gz
COPY apache/software/apr-$APR_VERSION.tar.gz /opt/apr-$APR_VERSION.tar.gz
COPY apache/software/pcre-$PCRE_VERSION.tar.gz /opt/pcre-$PCRE_VERSION.tar.gz
COPY php5.3/software/php-$PHP_VERSION.tar.gz /opt/php-$PHP_VERSION.tar.gz
COPY php5.3/software/xdebug-$XDEBUG_VERSION.tgz /opt/xdebug-$XDEBUG_VERSION.tgz

#环境准备
RUN yum install -y gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses curl openssl-devel gdbm-devel db4-devel libXpm-devel libX11-devel gd-devel gmp-devel readline-devel libxslt-devel expat-devel xmlrpc-c xmlrpc-c-devel libtool libtool-ltdl libtool-ltdl-devel tar wget telnet mysql-devel \
	&& yum clean all

#apr 
RUN cd /opt/ \
#	&& wget http://apache.mirrors.pair.com/apr/apr-$APR_VERSION.tar.gz \
	&& tar -xzvf apr-$APR_VERSION.tar.gz \
	&& cd apr-$APR_VERSION \
	&& sed -i "s/RM='\$RM'/RM='\$RM -f'/g" configure \
	&& ./configure --prefix=/usr/local/apr \
	&& make \
	&& make install \
	&& cd ../ \
	&& rm -rf apr-$APR_VERSION*

#apr-util
RUN cd /opt/ \
#	&& wget http://apache.mirrors.pair.com/apr/apr-util-$APR_UTIL_VERSION.tar.gz \
	&& tar -xzvf apr-util-$APR_UTIL_VERSION.tar.gz \
	&& cd apr-util-$APR_UTIL_VERSION \
	&& ./configure --prefix=/usr/local/apr-util -with-apr=/usr/local/apr/bin/apr-1-config \
	&& make \
	&& make install \
	&& cd ../ \
	&& rm -rf apr-util-$APR_UTIL_VERSION*

#pcre
RUN cd /opt/ \
#	&& wget http://heanet.dl.sourceforge.net/project/pcre/pcre/$PCRE_VERSION/pcre-$PCRE_VERSION.tar.gz \
	&& tar -xzvf pcre-$PCRE_VERSION.tar.gz \
	&& cd pcre-$PCRE_VERSION \
	&& ./configure --prefix=/usr/local/pcre \
	&& make \
	&& make install \
	&& cd ../ \
	&& rm -rf pcre-$PCRE_VERSION*

#apache
RUN cd /opt/ \
#	&& wget http://apache.osuosl.org//httpd/httpd-$APACHE_VERSION.tar.gz \
	&& tar -xzvf httpd-$APACHE_VERSION.tar.gz \
	&& cd httpd-$APACHE_VERSION \
	&& ./configure \
		--prefix=/usr/local/apache \
		--with-apr=/usr/local/apr \
		--with-apr-util=/usr/local/apr-util/ \
		--with-pcre=/usr/local/pcre \
		--enable-so \
		--enable-proxy \
		--enable-cgi \
		--enable-mime-magic \
		--enable-expires \
		--enable-info \
		--enable-rewrite \
	&& make \
	&& make install \
	&& sed -i "s/#ServerName www.example.com:80/ServerName localhost/g" /usr/local/apache/conf/httpd.conf \
	&& cd ../ \
	&& rm -rf httpd-$APACHE_VERSION*

# php5.3
RUN cd /opt/ \
	&& tar -xzvf php-$PHP_VERSION.tar.gz \
	&& cd php-$PHP_VERSION \
	# 解决 「error: Cannot find libmysqlclient_r under /usr」
	&& ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib/ \
	# 解决 「error: Cannot find libmysqlclient_r under /usr」
	&& ln -s /usr/lib64/mysql/libmysqlclient_r.so /usr/lib/ \
	&& ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache/bin/apxs --with-mysql --with-pdo-mysql \
	&& make \
	&& make install \
	&& cp /opt/php-$PHP_VERSION/php.ini-development /usr/local/php/php.ini \
	&& cd ../ \
	&& rm -rf php-$PHP_VERSION*

# apache 中 php 配置
COPY php5.3/php.conf /usr/local/apache/conf/php.conf
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

CMD ["/usr/local/apache/bin/apachectl start"]
