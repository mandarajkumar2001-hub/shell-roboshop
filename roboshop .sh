#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-05b7ab0fa6a574779"
INSTANCES=("mongodb" "catalogue" "redis" "user" "payment" 
"shipping" "mysql" "rabbitmq" "cart" "Dispatch" "frontend")
zone_ID="Z01235012H9P8159XBCQ5"
DOMAIN_NAME=""roboshop.cyou"

for instance in ${INSTANCES[@]}
do
   INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t3.micro --security-group-ids sg-05b7ab0fa6a574779  --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi
    echo "$instance IP address: $IP"

done