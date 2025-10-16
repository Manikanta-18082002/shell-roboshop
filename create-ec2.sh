#!/bin/bash

instances=("mongodb" "redis" "mysql" "rabbitmq" "cart" "catalouge" "user" "shipping" "web" "payment")

for names in ${instances[@]}; do
    echo "Creating instance for: $names"    
done;