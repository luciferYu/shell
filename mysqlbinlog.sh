#!/bin/bash
#
#auth by zhiyi
#use mysqlbinlog dump binlog from db to result-file
#
#use under command lookup changelog
#oms_fruitday@oms-master:(none)>show binary logs;
#	...
#	...
# mysql-bin-changelog.146361 |   4085114 |
#| mysql-bin-changelog.146362 |   1085609 |
#| mysql-bin-changelog.146363 |   1567695 |
#| mysql-bin-changelog.146364 |   6535651 |
#| mysql-bin-changelog.146365 |   1516838 |
#| mysql-bin-changelog.146366 |   1222189 |
#| mysql-bin-changelog.146367 |    618319 |
#+----------------------------+-----------+
#2026 rows in set (0.01 sec)

#
#mysqlbinlog \
/usr/local/mem/mysql/bin/mysqlbinlog \
    --read-from-remote-server \
    --host=oms-datebase-production.cojrgnkwdopu.rds.cn-north-1.amazonaws.com.cn \
    --port=3306  \
    --database=fruitday_osm \
    --user=oms_fruitday \
    --start-datetime="2017-05-20 00:00:00" \
    --stop-datetime="2017-05-22 23:59:59" \
    --password=xxxxxxxxxxxx \
    --result-file=/tmp/fruitday-binlog-20170522.sql  \
    --to-last-log \
    mysql-bin-changelog.142809

#--exclude-gtids

