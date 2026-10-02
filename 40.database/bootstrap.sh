#!/bin/bash

component=$1 #mongodb
env=$2 #dev
dnf install ansible -y
mkdir -p /var/log/roboshop/
chown -R ec2-user:ec2-user /var/log/roboshop
chmod -R 755 /var/log/roboshop
touch /var/log/roboshop/ansible.log

cd /home/ec2-user
git clone https://github.com/Sudhakar20000/Ansible_v3.git
cd Ansible_v3
git pull
ansible-playbook -e component=$component -e env=$env roboshop.yaml