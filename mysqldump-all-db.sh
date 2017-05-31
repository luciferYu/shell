#!/bin/bash
#auth：zhiyi
#
#
#use to dump rds mysql databases dump all db
#
#db='fruitday_sap'
#host='fruitdata.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn'
#username='fruitadmin'
#file='/tmp/fruitday_sap20161009.sql'
#password='xxXXXXXXXXX'
#echo $file
#mysqldump -h${host} -u${username} -p${password} --default-character-set=utf8 ${db} > ${file}
#host=$1
#username=$2
#password=$3

host='pms-database.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn'
username='admin'
password='XXXX'
for dbname in `mysql -h${host} -u${username} -p${password} -e "show databases;"|grep -Evi "information|performance|mysql|database|tmp|innodb|sys"`
do
   echo $dbname
   if [ ! -d ./sql/"$(date +%Y-%m-%d)" ];then
       mkdir -p ./sql/"$(date +%Y-%m-%d)" 
   fi

   mysqldump -h${host} -u${username} -p${password} --single-transaction --master-data=2 -B $dbname |gzip > ./sql/"$(date +%Y-%m-%d)"/${dbname}_$(date +"%Y-%m-%d %H:%M:%S")_bak.sql.gz
   echo $dbname " back end"
done  
