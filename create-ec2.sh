#!/bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "cart" "catalouge" "user" "shipping" "web" "payment")

for names in ${instances[@]}; do
    if [ $names == "shipping" ] || [ $names == "mysql" ]
    then 
        instance_type="t3.medium"
    else
        instance_type="t3.micro"
    fi
    echo "Creating instance for: $names with instance type: $instance_type"

    instance_id=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type $instance_type --security-group-ids sg-012dd7c404cb8524d --subnet-id subnet-007b7e3b8abb1e65a --query 'Instances[0].InstanceId' --output text)
    echo "Instance created for: $name"
done