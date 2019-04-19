#!/bin/bash

yum -y install git
cd /root
git clone https://github.com/hank6/nginx.git
cd /root/nginx

# build image:
docker build -t nginx:v1 -f /root/nginx/dockerfile  .

# create container:
docker run -d -p 8080:80 --name ngx_test nginx:v1
