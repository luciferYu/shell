#!/bin/bash
#auth by zhiyi
#
#
#ec2-user@ip-192-168-80-159 monitor]$ cat ~/.bashrc
#alias mysql_XXX='mysql -hXXX.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn -uDbadmin -pDbpassword --prompt="\\u@XXX:\\d>" -U'
#
#
#[ec2-user@ip-192-168-80-159 monitor]$ sh get-rds-block-trx.sh mysql_oms
#
#
source ~/.bashrc
if [[ -z $1 ]];then
    echo 'please input connection string'
    exit
else
    cmd=${1}' -e "SELECT lw.requesting_trx_id AS request_ID,trx.trx_mysql_thread_id as request_mysql_ID,trx.trx_query AS request_command,lw.blocking_trx_id AS blocking_ID,trx1.trx_mysql_thread_id as blocking_mysql_ID,trx1.trx_query AS blocking_command,lo.lock_index AS lock_index FROM information_schema.innodb_lock_waits lw INNER JOIN information_schema.innodb_locks lo ON lw.requesting_trx_id = lo.lock_trx_id INNER JOIN information_schema.innodb_locks lo1 ON lw.blocking_trx_id = lo1.lock_trx_id INNER JOIN information_schema.innodb_trx trx ON lo.lock_trx_id = trx.trx_id INNER JOIN information_schema.innodb_trx trx1 ON lo1.lock_trx_id = trx1.trx_id\G;"'
    eval $cmd
fi
