#!/bin/bash

echo "Starting script..."

sudo apt update
sudo apt upgrade -y
sudo apt install net-tools
sudo apt install nmap -y
sudo snap install metasploit-framework

echo "Script completed."