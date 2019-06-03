#!/bin/bash

set -euxo pipefail

for i in login01 cn01 cn02 cn03 cn04 fat01 
do
	ssh $i "umount -f /lustre"
done

#ssh mdt 10.1.1.100
#umount /mdt
ssh 10.1.1.100 "umount /mdt"

#ssh ost 10.1.1.101 10.1.1.102
#umount /ost
ssh 10.1.1.101 "umount /ost"
ssh 10.1.1.102 "umount /ost"
