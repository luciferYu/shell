#!/bin/bash
#auth:zhiyi
#
#dump single table to file
#
#
#
stty erase ^H
read -p "please input your Database Connection String:" host
read -p "please input your db username:" username
read -p "please input your db password:" password
read -p "please input your db name:" db
read -p "please input your db table:" table
 
   if [ ! -d ./sql/"$(date +%Y-%m-%d)" ];then
       mkdir -p ./sql/"$(date +%Y-%m-%d)" 
   fi
  filename=${db}"."${table}_$(date +"%Y-%m-%d %H:%M:%S")_bak.sql.gz 

   mysqldump -h${host} -u${username} -p${password} --default-character-set=utf8 ${db} ${table}  |gzip > ./sql/"$(date +%Y-%m-%d)"/$filename
   echo $db " back to " $filename 
