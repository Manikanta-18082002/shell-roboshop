#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2...$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2...$G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "Disable nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Install nodejs"

id roboshop &>> $LOG_FILE
if [ $? -ne 0]
then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
else
    echo -e "User already exists... $Y SKIPPING $N"


mkdir /app &>> $LOG_FILE
VALIDATE $? "Creating /app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOG_FILE
VALIDATE $? "Downloading Catalouge application"

cd /app  &>> $LOG_FILE
VALIDATE $? "Moving into /app directory"

unzip /tmp/catalogue.zip &>> $LOG_FILE
VALIDATE $? "Extracting Catalouge"

npm install  &>> $LOG_FILE
VALIDATE $? "Installing dependencies"

cp catalouge.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
VALIDATE $? "Copying Systemctl services"

systemctl daemon-reload &>> $LOG_FILE
systemctl enable catalogue  &>> $LOG_FILE
VALIDATE $? "Enabling catalouge"

systemctl start catalogue &>> $LOG_FILE
VALIDATE $? "Start catalouge"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Install MongoDB client"

mongosh --host mongodb.dawsmani.site </app/db/master-data.js &>> $LOG_FILE

systemctl restart catalogue
VALIDATE $? "Restarted catalogue"

