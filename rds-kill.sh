#!/bin/bash
#auth by zhiyi
#
#
#ec2-user@ip-192-168-80-159 monitor]$ cat ~/.bashrc
#alias mysql_open='mysql -hXXX.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn -uDbadmin -pDbpassword --prompt="\\u@XXX:\\d>" -U'
#
#
source ~/.bashrc
#mysql_recmd -e "select Id from information_schema.processlist where Time > 100 and Info like '%LIMIT  0,100'" > slowquery
#mysql_dz -e "select Id from information_schema.processlist where Time > 100 and db like 'open_%' " > slowquery
mysql_open -e "select Id from information_schema.processlist where Time > 100 and db like 'open_send' " > slowquery
while read line;do
killstr='mysql_open -e "CALL mysql.rds_kill('${line}');"'
echo $line
eval $killstr
done < slowquery
