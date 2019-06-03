#!/bin/bash

set -euxo pipefail

#mds
#mount -t lustre /dev/sdb /mdt/

#oss
#mount -t lustre /dev/mapper/data /ost/

#client
#mount -t lustre 172.1.1.100@tcp0:/lustre /lustre



for i in cn01 cn02 cn03 cn04 fat01
do
	ssh $i "mount -t lustre -o localflock 172.1.1.100@tcp:/lustre /lustre"
done


qmod -e *
