#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &>> $LOGFILE

echo "script stareted executing at $TIMESTAMP" 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf install nginx -y

VALIDATE $? "Installing Nginx"

systemctl enable nginx

VALIDATE $? "enabling Nginx"

systemctl start nginx

VALIDATE $? "starting Nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "removing default html content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "download web.zip"

cd /usr/share/nginx/html

VALIDATE $? "changing to html directory"

unzip -o /tmp/web.zip

VALIDATE $? "unzipping web.zip"

cp /home/centos/shell-scripting/roboshop.conf /etc/nginx/default.d/roboshop.conf

VALIDATE $? "copying roboshop.conf"

systemctl restart nginx

VALIDATE $? "restarting nginx"