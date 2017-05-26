#!/bin/bash
#auth by zhiyi
#
#
#ec2-user@ip-192-168-80-159 monitor]$ cat ~/.bashrc
#alias mysql_open='mysql -hXXX.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn -uDbadmin -pDbpassword --prompt="\\u@XXX:\\d>" -U'
#
#
#[ec2-user@ip-192-168-80-159 monitor]$ sh get-rds-size.sh mysql_open
#+---------------------+--------------------+----------+---------+----------+--------+
#| table_schema        | engine             | total_mb | data_mb | index_mb | tables |
#+---------------------+--------------------+----------+---------+----------+--------+
#| open_order          | InnoDB             |     2329 |    1960 |      369 |     38 |
#| open_authentication | InnoDB             |     1516 |    1503 |       13 |     41 |
#| wms_api             | InnoDB             |      556 |     554 |        3 |      8 |
#| open_send           | InnoDB             |       92 |      88 |        4 |     17 |
#| mysql               | MyISAM             |        6 |       3 |        2 |     22 |
#| open_batch          | InnoDB             |        1 |       1 |        0 |     20 |
#| information_schema  | MEMORY             |        0 |       0 |        0 |     49 |
#| mysql               | InnoDB             |        0 |       0 |        0 |     12 |
#| performance_schema  | PERFORMANCE_SCHEMA |        0 |       0 |        0 |     52 |
#| mysql               | CSV                |        0 |       0 |        0 |      2 |
#| information_schema  | MyISAM             |        0 |       0 |        0 |     10 |
#+---------------------+--------------------+----------+---------+----------+--------+
#
#
source ~/.bashrc
if [[ -z $1 ]];then
    echo 'please input connection string'
    exit
else
    #cmd=${1}' -e "select table_schema,engine,round(sum(data_length+index_length)/1024/1024) as total_mb,round(sum(data_length)/1024/1024) as data_mb,round(sum(index_length)/1024/1024) as index_mb,count(*) as tables from information_schema.tables  group by table_schema,engine order by 3  desc\G;"'
    cmd=${1}' -e "select table_schema,engine,round(sum(data_length+index_length)/1024/1024) as total_mb,round(sum(data_length)/1024/1024) as data_mb,round(sum(index_length)/1024/1024) as index_mb,count(*) as tables from information_schema.tables  group by table_schema,engine order by 3  desc;"'
    eval $cmd
fi
