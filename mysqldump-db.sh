#!/bin/bash
#auth:zhiyi
#
#dump single db from rds to a file
#
stty erase ^H
read -p "please input your Database Connection String:" host
read -p "please input your db username:" username
read -p "please input your db password:" password
read -p "please input your db name:" db
 
   if [ ! -d ./sql/"$(date +%Y-%m-%d)" ];then
       mkdir -p ./sql/"$(date +%Y-%m-%d)" 
   fi
  filename=${db}_$(date +"%Y-%m-%d %H:%M:%S")_bak.sql.gz 

  # mysqldump -h${host} -u${username} -p${password} --single-transaction --master-data=2 --default-character-set=utf8 ${db}  |gzip > ./sql/"$(date +%Y-%m-%d)"/$filename
  # mysqldump -h${host} -u${username} -p${password} --routines  --default-character-set=utf8 ${db}  |gzip > ./sql/"$(date +%Y-%m-%d)"/$filename
   mysqldump -h${host} -u${username} -p${password}  --default-character-set=utf8 --single-transaction  ${db}  |gzip > ./sql/"$(date +%Y-%m-%d)"/$filename
   echo $db " back to " $filename 
