#!/bin/bash

#Quota for local filesystem, default 1G
LOCALQUOTA=1048576
#Quota for lustre filesystem, default 5T
LFSSOFTQUOTA='4900G'
LFSHARDQUOTA='5T'

echo -e "User Name?"

read User

echo -e "Department?"

read Dep

groupadd $Dep

mkdir /lustre/home/${User}
chmod 755 /lustre/home/${User}

useradd $User -G $Dep
PASSWORD=`openssl rand -base64 16`
echo "${PASSWORD}" | passwd "$User" --stdin 

#500M, 1024 block size = 524288
#1G, 1048576
#setquota -u -F vfsv0 bob 1048576 1048576 1000000 1000000 /
#首先设置本地quota
setquota -u $User ${LOCALQUOTA} ${LOCALQUOTA} 100000 200000 /
repquota /

#不再同步/etc/shadow，仅通过sge提交任务
#rocks sync users
scp /etc/passwd 10.1.1.100:/etc/passwd
scp /etc/group 10.1.1.100:/etc/group

for host in cn01 cn02 cn03 cn04 fat01
do
	scp /etc/passwd ${host}:/etc/passwd
	scp /etc/group ${host}:/etc/group
done


#设置lustre的quota
lfs setquota -u $User  -b ${LFSSOFTQUOTA} -B ${LFSHARDQUOTA}  /lustre 
lfs quota -u  $User /lustre/

#改权限
chown ${User}:${User} /lustre/home/${User}
mkdir /lustre/home/${User}/.ssh
chown ${User}:${User} /lustre/home/${User}/.ssh
touch /lustre/home/${User}/.ssh/authorized_keys
chmod 600 /lustre/home/${User}/.ssh/authorized_keys

echo "Add user ${User} successfully"
echo "Password is ${PASSWORD}"

echo "${User}，
你好，你的超算账号已经开通，登陆方式如下：
ssh地址: 192.168.119.150
用户名： ${User}
密码： ${User}.op[]90-=

注意事项：
超算账号仅限本人使用，严禁外借，作业使用SGE调度系统提交，禁止在登陆节点直接运行，参考脚本见/lustre/local/bin/qsub_example.sh
使用时请遵守超算管理规定，共同爱护超算的环境 

祝好!
"

#同时删除目录的用户删除方法
#userdel -r xxyyxx

#用户资源限制
#/etc/security/limits.conf 
