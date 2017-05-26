#!/bin/bash
#auth:zhiyi
#编辑一个名字叫portnew的文件（内容如下）和这个脚本放在同一目录下
#一行代表一个监控项
#IP:端口：告警邮箱：主机名称：断网次数（初始为0）
#[root@ZJ-zabbix ~]# cat portnew
#10.28.20.52:4440:yuzy@fruXXXay.com:master02:0
#54.223.50.120:80:138XXXXXXXX@139.com,zhouxw@fruitday.com:DAS-QILKVIEW:0
#编辑crontab设置监控间隔 
#add this script to crontab use crontab -e
#[root@ZJ-zabbix ~]# crontab -l
#*/3 * * * * sh /root/portnew.sh
#设置邮件
#[root@ZJ-zabbix ~]# tail -n 7  /etc/mail.rc 

#set from=monitor@youremail.com
#set smtp=smtp.youremail.com
#set smtp-auth-user=monitor@youremail.com
#set smtp-auth-password="YourEmailPassword"
#set smtp-auth=login






function getportstatus()
{
  IP=$(echo $@ |cut -d ':' -f1)
  PORT=$(echo $@ |cut -d ':' -f2)
  EMAIL=$(echo $@ |cut -d ':' -f3)
  INFO=$(echo $@ |awk -F ':' '{print $4}')
  FLAG=$(echo $@ |awk -F ':' '{print $NF}')
  STATUS=$(/usr/bin/nmap -p$PORT $IP|grep -w $PORT|cut -d ' ' -f 2)
#echo $STATUS
#echo $EMAIL
#echo $IP "---" $PORT "---" $FLAG "---"$STATUS
#echo $@
#echo $FLAG

   if [[ $STATUS == "" ]] || [[ $STATUS == "closed" ]] || [[ $STATUS == "filtered" ]];then
   awk 'BEGIN{FS=OFS=":"} $2=="'${PORT}'" && $1=="'${IP}'" {$NF=$NF+1}1 {print $0 > "/root/portnew"}' /root/portnew
   else
   awk 'BEGIN{FS=OFS=":"} $2=="'${PORT}'" && $1=="'${IP}'" {$NF=0}1 {print $0 > "/root/portnew"}' /root/portnew
   fi

   if [[ $FLAG -ge 5 ]];then
      echo $INFO $IP ":" $PORT "已连续断网"$FLAG"次！"|mailx -s "断网警报" $EMAIL
   fi

}

cat /root/portnew |while read line
do

getportstatus $line

done

