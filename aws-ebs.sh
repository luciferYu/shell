#!/bin/bash
#auth zhiyi
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
#
#[ec2-user@ip-192-168-80-159 aws]$ cat ./report/aws-ebs-20170526
#"standard"  1480
#"gp2"  10580
#
#

ilist=$(aws ec2 describe-volumes|jq '.Volumes[].VolumeId')
#another profile
#ilist=$(aws ec2 describe-volumes --profile web|jq '.Volumes[].VolumeId')
for ins in ${ilist}
do
ins=`echo $ins|awk -F '"' '{print $2}'`
size=$(aws ec2 describe-volumes --volume-ids ${ins} |jq ".Volumes[].Size")
VolumeType=$(aws ec2 describe-volumes --volume-ids ${ins} |jq ".Volumes[].VolumeType")
echo $VolumeType":"$size >> ./ebs
done
cat ./ebs|awk -F ':' '{types[$1]+=$2;}END{for(i in types) printf "%s  %d\n",i,types[i]}' > ./report/aws-ebs-$(date +%Y%m%d)
rm ./ebs
