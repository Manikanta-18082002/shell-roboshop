#!/bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "cart" "catalouge" "user" "shipping" "web" "payment")

for names in ${instances[@]}; do
    if [ $names == "shipping"] || [ $names == "mysql" ]
    then 
        instance_type="t3.medium"
    else
        instance_type="t3.micro"
    fi
    echo "Creating instance for: $names with instance type: $instance_type"
done