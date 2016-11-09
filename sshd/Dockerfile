FROM centos:6.6
MAINTAINER rubberBoy <gaosheng08@gmail.com>

RUN yum install passwd openssl openssh-server -y
RUN ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key \
        && ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key \
        && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" \
        && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

EXPOSE 22
