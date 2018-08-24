---
layout: post
title:  MySQL Install
category: tech
tag: tools
--- 

#### install
mac:`brew install mysql`
ubuntu:`sudo apt-get install mysql-server `

#### setup
首先启动mysql:`mysql.server start`
初始化并设置root密码：`mysql_secure_installation`

##### some error
ERROR 1146 (42S02): Table 'mysql.role_edges' doesn't exist:`sudo mysql_upgrade -u root -p`


#### allow remote
ubuntu:
1. 编辑`/etc/mysql/mysql.conf.d/mysqld.cnf`文件，并注释`bind-address = 127.0.0.1`,
1. 重启mysql：`sudo /etc/init.d/mysql restart`