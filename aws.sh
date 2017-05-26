#!/bin/bash
#auth: zhiyi
#
# compare rds ec2 instances to ec2 reservation instances
# write result to file aws-report-date 
# amount reservations count on left and amount instances count on right
#[ec2-user@ip-192-168-80-159 aws]$ cat report/aws-report-20170525 
#reserve  c3.4xlargecn-north-1a  1  1  c3.4xlarge:cn-north-1a
#reserve  c4.2xlargecn-north-1a  1  1  c4.2xlarge:cn-north-1a
#reserve  m3.2xlargecn-north-1a  6  6  m3.2xlarge:cn-north-1a
#reserve  m3.largecn-north-1a    3  3  m3.large:cn-north-1a
#reserve  m3.largecn-north-1b    2  2  m3.large:cn-north-1b
#reserve  m3.mediumcn-north-1a   1  1  m3.medium:cn-north-1a
#
#need install aws cli and jq
#wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip 
#unzip awscli-bundle.zip 
#sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
#
#aws configure
#
#[ec2-user@ip-192-168-80-159 ~]$ cat ~/.aws/config 
#[default]
#region = cn-north-1
#[profile web]
#region = cn-north-1
#
#
#[ec2-user@ip-192-168-80-159 ~]$ cat ~/.aws/credentials 
#[default]
#aws_access_key_id = XXXXXXXXXXXXXXXXX
#aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#[web]
#aws_access_key_id = XXXXXXXXXXXXXXXXX
#aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#

ilist=$(aws ec2 describe-instances|jq '.Reservations[].Instances[].InstanceId')
#another profile
#ilist=$(aws ec2 describe-instances --profile web|jq '.Reservations[].Instances[].InstanceId')

for ins in ${ilist}
do
ins=`echo $ins|awk -F '"' '{print $2}'`
     #id=$(aws ec2 describe-instances --instance-ids ${ins} |jq .Reservations[].Instances[].InstanceId)
     id="$(aws ec2 describe-instances --instance-ids ${ins}|jq ".Reservations[].Instances[].InstanceId"|awk -F '"' '{print $2}')"
     itype="$(aws ec2 describe-instances --instance-ids ${ins}|jq ".Reservations[].Instances[].InstanceType"|awk -F '"' '{print $2}')"
     iaz="$(aws ec2 describe-instances --instance-ids ${ins}|jq ".Reservations[].Instances[].Placement.AvailabilityZone"|awk -F '"' '{print $2}')"
     ipltf="$(aws ec2 describe-instances --instance-ids ${ins}|jq ".Reservations[].Instances[].Platform"|awk -F '"' '{print $2}')"
     iip="$(aws ec2 describe-instances --instance-ids ${ins}|jq ".Reservations[].Instances[].PrivateIpAddress"|awk -F '"' '{print $2}')"
     echo $id":"$itype":"$iaz":"$ipltf":"$iip >> ./instance
done

riid=$(aws ec2 describe-reserved-instances|jq '.ReservedInstances[].ReservedInstancesId')
for rid in ${riid}
do 
  rid=`echo $rid|awk -F '"' '{print $2}'`
  id="$(aws ec2 describe-reserved-instances --reserved-instances-ids ${rid}|jq ".ReservedInstances[].ReservedInstancesId"|awk -F '"' '{print $2}')"
  rtype="$(aws ec2 describe-reserved-instances --reserved-instances-ids ${rid}|jq ".ReservedInstances[].InstanceType"|awk -F '"' '{print $2}')"
  raz="$(aws ec2 describe-reserved-instances --reserved-instances-ids ${rid}|jq ".ReservedInstances[].AvailabilityZone"|awk -F '"' '{print $2}')"
  ric="$(aws ec2 describe-reserved-instances --reserved-instances-ids ${rid}|jq ".ReservedInstances[].InstanceCount")"
  rstat="$(aws ec2 describe-reserved-instances --reserved-instances-ids ${rid}|jq ".ReservedInstances[].State"|awk -F '"' '{print $2}')"
  echo $id":"$rtype":"$raz":"$ric":"$rstat >> ./ri 

done
cat ./instance |sort -k 2 -t :|awk -F ':' '{print $2":"$3}'|uniq -c >> ./ti
cat ri|grep active|sort -k 3 -t :|sort -k 2 -t :|awk -F ':' '{print $2$3":"$4}'|awk -F ':' '{types[$1]+=$2;}END{for(i in types) printf"reserve %s  %d\n",i,types[i]}' |sort -k 1 >> ./tr
paste -d "\t" tr ti  > ./tmp
cat ./tmp|column -t > ./report/aws-report-$(date +%Y%m%d) 
rm ./instance
rm ./ri
rm ./ti
rm ./tr
rm ./tmp
