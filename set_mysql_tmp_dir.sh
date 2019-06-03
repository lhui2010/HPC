for i in cn01 cn02 cn03 cn04 fat01
do
	ssh $i "mkdir /state/partition1/tmp && chmod 777 /state/partition1/tmp"
done
