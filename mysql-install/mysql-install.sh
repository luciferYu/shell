#!/bin/bash
#this script install mysql
#please input cmake-3.2.1.tar.gz  cmake.sh  mysql-5.6.23.tar.gz into /usr/local/src
#0 iptables off
service iptables stop
chkconfig --level 345 iptables off
#1.install depedency lib
yum -y install openssl-devel ncurses-devel bison gcc make gcc-c++
#2.unzip tar.gz
tar -zxvf /usr/local/src/mysql-5.6.23.tar.gz 
tar -zxvf cmake-3.2.1.tar.gz
#3.install cmake
cd /usr/local/src/cmake-3.2.1
./configure
gmake
make install
#3.add mysql user
groupadd mysql
useradd -g mysql mysql -s /sbin/nologin
mkdir /mysql
mkdir /mysql/data
chown -R mysql:mysql /mysql
mkdir /usr/local/mysql
chown -R mysql:mysql /usr/local/mysql
#oinstall mysql
cp /usr/local/src/cmake.sh /usr/local/src/mysql-5.6.23
chmod 777 /usr/local/src/mysql-5.6.23/cmake.sh
cd /usr/local/src/mysql-5.6.23/
./cmake.sh
gmake
make install
#init mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
\cp  /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
sed -i 's/# socket = ...../socket = \/tmp\/mysqld.sock/g' /etc/my.cnf
echo '[client]' >> /etc/my.cnf
echo 'default-character-set=utf8' >> /etc/my.cnf
echo 'socket=/tmp/mysqld.sock' >> /etc/my.cnf
echo '[mysql]' >> /etc/my.cnf
echo 'default-character-set=utf8' >> /etc/my.cnf
echo 'socket=/tmp/mysqld.sock' >> /etc/my.cnf
chmod 755 /etc/init.d/mysql
chkconfig --add mysql
chkconfig mysql on
sed -i 's/PATH=$PATH:$HOME\/bin/PATH=$PATH:$HOME\/bin:\/usr\/local\/mysql\/bin/g' /root/.bash_profile
source /root/.bash_profile
#install mysqldb
cd /usr/local/mysql/scripts/
./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/mysql/data
service mysql start
#set root password
mysqladmin -h127.0.0.1 -uroot password 'password@123'
