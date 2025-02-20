#!/bin/bash

apt update --fix-missing && apt upgrade -y 
apt install wget build-essential libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev nano -y 
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tar.xz
tar xvf Python-3.11.0.tar.xz
cd Python-3.11.0
./configure --prefix=/usr/local/python3.11 --enable-optimizations --enable-loadable-sqlite-extensions
#--enable-optimizations为优化性能选项，--prefix=PATH 指定安装目录，可根据需要进行选择。
#默认安装路径为 /usr/local/bin
make -j 4
make install
rm Python-3.11.0.tar.xz
rm -rf Python-3.11.0
rm /usr/bin/python3 -rf 
rm /usr/bin/python -rf 
rm /usr/bin/pip3 -rf
rm /usr/bin/pip -rf
ln -s /usr/local/python3.11/bin/python3.11 /usr/bin/python3
ln -s /usr/local/python3.11/bin/python3.11 /usr/bin/python
ln -s /usr/local/python3.11/bin/pip3.11 /usr/bin/pip3
ln -s /usr/local/python3.11/bin/pip3.11 /usr/bin/pip