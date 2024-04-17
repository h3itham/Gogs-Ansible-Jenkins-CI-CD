#!/bin/bash

# Create users
echo "Creating Users..."
sudo useradd -m Dev
sudo useradd -m Test
sudo useradd -m Prod

# Create group
echo "Creating nginxG group..."
sudo groupadd nginxG

# Add users to group
sudo usermod -aG nginxG Dev
sudo usermod -aG nginxG Test
sudo usermod -aG nginxG Prod

echo "Users (Dev, Test, Prod) created and added to the 'nginxG' group."
