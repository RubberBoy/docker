FROM centos:6.6
MAINTAINER rubberBoy <gaosheng08@gmail.com>

COPY software/httpd-2.4.23.tar.gz /opt/httpd-2.4.23.tar.gz
COPY software/apr-util-1.5.4.tar.gz /opt/apr-util-1.5.4.tar.gz
COPY software/apr-1.5.2.tar.gz /opt/apr-1.5.2.tar.gz
COPY software/pcre-8.39.tar.gz /opt/pcre-8.39.tar.gz

#环境准备
RUN yum install -y gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses curl openssl-devel gdbm-devel db4-devel libXpm-devel libX11-devel gd-devel gmp-devel readline-devel libxslt-devel expat-devel xmlrpc-c xmlrpc-c-devel libtool libtool-ltdl libtool-ltdl-devel tar wget telnet mysql-devel

ENV APR_VERSION 1.5.2
ENV APR_UTIL_VERSION 1.5.4
ENV PCRE_VERSION 8.39
ENV APACHE_VERSION 2.4.23

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

EXPOSE 80

CMD ["/usr/local/apache/bin/apachectl start"]
