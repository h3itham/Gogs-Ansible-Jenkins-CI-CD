#!/bin/bash
# Retrieve users in nginxG group and save them to users.txt
getent group nginxG > users.txt
