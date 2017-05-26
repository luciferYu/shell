#!/bin/sh
#auth by zhiyi
#
#
#ec2-user@ip-192-168-80-159 monitor]$ cat ~/.bashrc
#alias mysql_open='mysql -hXXX.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn -uDbadmin -pDbpassword --prompt="\\u@XXX:\\d>" -U'
#
#
#[ec2-user@ip-192-168-80-159 monitor]$ sh rds-show-processlist.sh osm
#fruitday_osm
#*************************** 1. row ***************************
#     ID: 347
#   USER: rdsrepladmin
#   HOST: 10.18.0.143:38267
#     DB: NULL
#COMMAND: Binlog Dump
#   TIME: 1026187
#  STATE: Master has sent all binlog to slave; waiting for binlog to be up
#   INFO: NULL
#-------------------------------------------------------
#please use mysql_oms -e "CALL mysql.rds_kill(id);"
#please use mysql_oms -e "CALL mysql.rds_kill(347);"

source ~/.bashrc
if [[ -z $1 ]];then
    echo 'please input dbname'
    exit
fi
for list in $(grep alias ~/.bashrc|grep -v '^#'|grep 'mysql'|awk -F '=' '{print $1}'|awk '{print $2}');do
comm="$list -e \"show databases;\""
eval  $comm|grep $1  
if [ $? == 0 ]; then
   sp=${list}' -e "select * from information_schema.PROCESSLIST where COMMAND != '\''Sleep'\'' and TIME > 200 order by TIME desc limit 10\G;"'
   eval "$sp"
   echo '-------------------------------------------------------'
   TMP=$( source ~/.bashrc;sql='select id from information_schema.PROCESSLIST where COMMAND != '\''Sleep'\'' and TIME > 200 order by TIME desc limit 10;';eval "${list} -e \"${sql}\"" );
   for ID in  $TMP;do
        echo 'please use '$list' -e "CALL mysql.rds_kill('$ID');"'
   done
   #echo 'please use '$list' -e "CALL mysql.rds_kill(id);"'
fi

done
