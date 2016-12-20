FROM centos:6.6
MAINTAINER rubberBoy <gaosheng08@gmail.com>

RUN yum install -y httpd \
	&& sed -i "s/#ServerName www.example.com:80/ServerName localhost/g" /etc/httpd/conf/httpd.conf \
	&& yum install -y php php-mbstring php-mysql php-pecl-memcache php-devel php-pear gcc gcc-c++ autoconf automake \
	&& yum clean all \
	#yum install php-pecl-xdebug #cents6.6 好像没有xdebug，使用下面的pecl命令安装
	&& pecl install xdebug-2.2.7

EXPOSE 80

CMD ["httpd", "-DFOREGROUND"]