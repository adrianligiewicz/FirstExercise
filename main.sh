#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx

mkdir /opt/app
mv ./index.html /opt/app/index.html

sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'ssh'
sudo ufw enable

sudo systemctl start nginx