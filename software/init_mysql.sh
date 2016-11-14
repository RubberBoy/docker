#!/bin/sh

cd $(cd "$(dirname "$0")"; pwd)

export LANG=zh_CN.GBK

MYSQL_DIR="/usr/local/mysql"
MYSQL_USER="mysql"
MYSQL_GROUP="mysql"
MAX_CONNECTIONS="3000"

################################################

#cp conf/mysql.service /etc/init.d/mysql
#cp conf/my.cnf /etc/my.cnf
#chmod 644 /etc/my.cnf

chown -R "$MYSQL_USER":"$MYSQL_GROUP" $MYSQL_DIR

sed -i '/^export MYSQL_HOME=/d' /home/"$MYSQL_USER"/.bash_profile
echo "export MYSQL_HOME=$MYSQL_DIR" >> /home/"$MYSQL_USER"/.bash_profile

sed -i '/^export PATH=$MYSQL_HOME/d' /home/"$MYSQL_USER"/.bash_profile
echo 'export PATH=$MYSQL_HOME/bin:$PATH' >> /home/"$MYSQL_USER"/.bash_profile

su - "$MYSQL_USER" -c 'cd '""$MYSQL_DIR""';./scripts/mysql_install_db' > /dev/null 2>&1

chkconfig --add mysql
chkconfig mysql on

service mysql start
"$MYSQL_DIR"/bin/mysql -uroot -e "delete from mysql.user where user!='root' or host!='localhost';"
"$MYSQL_DIR"/bin/mysql -uroot -e "truncate mysql.db;"
"$MYSQL_DIR"/bin/mysql -uroot -e "drop database test;"
#"$MYSQL_DIR"/bin/mysql_secure_installation

echo "mysql"

exit 0
