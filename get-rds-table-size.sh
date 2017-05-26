#!/bin/bash
#watch -n 5 "sh get-rds-table-size.sh mysql_recmd fruitday_recommendation"
#auth by zhiyi
#
#
#ec2-user@ip-192-168-80-159 monitor]$ cat ~/.bashrc
#alias mysql_open='mysql -hXXX.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn -uDbadmin -pDbpassword --prompt="\\u@XXX:\\d>" -U'
#
#
#[ec2-user@ip-192-168-80-159 monitor]$ sh get-rds-table-size.sh mysql_oms fruitday_osm
#+-----------------------------+------------+---------+----------+
#| table_name                  | table_rows | columns | total_mb |
#+-----------------------------+------------+---------+----------+
#| T_ORDER_EVENT               |   63393628 |      13 |    12080 |
#| T_ORDER_PRODUCT             |   25005759 |      37 |    11620 |
#| T_D_ORDER_SYN               |   13416722 |       6 |      651 |
#| T_ORDER_FEE                 |   11558230 |      42 |     4708 |
#
#
source ~/.bashrc
if [[ $# != 2 ]];then
    echo 'please input connstr and dbname'
    exit
else
    cmd=${1}' -e "use information_schema;select t1.table_name,t1.table_rows,t2.columns,round(sum(data_length+index_length)/1024/1024) as total_mb from tables as t1,(select table_name,count(1) as columns FROM information_schema.COLUMNS group by table_name) as t2 where t1.TABLE_SCHEMA ='\'${2}''\'' and t1.TABLE_NAME=t2.TABLE_NAME group by t1.table_name order by t1.table_rows desc;"'

    eval $cmd
fi
