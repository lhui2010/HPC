#!/bin/bash

set -euxo pipefail

for i in cn01 cn02 cn03 cn04 fat01 10.1.1.100 
do
	echo "shutting down $i .."
	ssh $i "shutdown now"
done

ssh 10.1.1.101 "shutdown +1"
ssh 10.1.1.102 "shutdown +1"
