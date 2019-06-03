User=zhuanghuifu

useradd $User -G wujianqiang,admin
echo "${User}.op[]90-=" | passwd "$User" --stdin 

#usermod -a -G wujianqiang,admin $User 

#500M, 1024 block size = 524288
#1G, 1048576
#setquota -u -F vfsv0 bob 1048576 1048576 1000000 1000000 /
#首先设置本地quota
setquota -u $User 1048576 1048576 100000 200000 /
repquota /
#然后设置lustre quota
#lfs setquota -u $User -b 499G -B 500G -i 100000 -I 110000 /lustre 
lfs setquota -u $User  -b 499G -B 500G  /lustre 
lfs quota -u  $User /lustre/

rocks sync users
scp /etc/passwd 172.1.1.100:/etc/passwd
scp /etc/group 172.1.1.100:/etc/group

mkdir /lustre/home/$User
chown $User:$User  /lustre/home/$User
ln -s /lustre/home/$User/ /export/home/$User/workdir

