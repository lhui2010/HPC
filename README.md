## Scripts for managing Cluster based on lustre and SGE (ROCKS7)

### User Management Scripts

add_user.sh

Usage: bash add_user.sh

### Lustre Management Scripts

In our case, cn01 cn02 cn03 cn04 fat01 is executing nodes. 
Node(10.1.1.100) is MGT. Node(10.1.1.101) and Node(10.1.1.102)
are OST nodes. Shutdown sequences is first MGT then OST. And 
power-on sequence is also first MGT then OST. [wiki](http://wiki.lustre.org/Starting_and_Stopping_Lustre_Services)

The job manager we used is SGE which is bundled with ROCKS7.

Main space of local storage are allocated to /state/partition1 on each node.


### HPC Power-off

* Step 1. Disable all queues in SGE and requeue all running jobs

```
bash shutdown_clustre/1.shutdown_sge.sh
```

* Step 2. Shutdown clustre

umount lustre filesystem from all nodes.

```
shutdown_clustre/2.stop_lustre.sh
```

* Step 3. Shutdown Linux machine

ssh to each node and execute shutdown command.

When shutdown Storage nodes, shutdown mgt first, then OST.

```
shutdown_clustre/3.shutdown.sh
```

* Step 4. shutdown login node 

Before shutdown login node, make sure lustre and rest nodes is off-line.

```
shutdown now
```

### HPC Power-on

* Step 1. Power on MGT and OST

Press the power button of MGT (first) and OST nodes.

* Step 2. Remount lustre FS and  enabling SGE queues 

Normally /mgt and /ost will be automounted. If there is 
a failure, you need to login to those nodes and mount manually.

The belowing scripts will remount lustre file system and enabling all SGE queues.

```
bash start_lustre.sh
```


### Miscellaneous

#### Disable ip v6 on all hosts

```
bash disable_ipv6.sh
```

#### Monitor memory and send warning to all users aboard 

This script calls monitor.pl every minutes. If memory exceeds
90% of total memory, it will send a warning to all users with 
 `wall` command. Therefore, you need to have root or sudoer privilege
 to run this script. I tried to use cron but failed due to SGE 
 environmental variable dependency.

```
nohup bash monitor.sh &
```

#### mkdir a tmp folder for each node

set_mysql_tmp_dir.sh

#### fstab for cn04

Default space for /tmp and /var is very low. So I mount two directory
from local space to those two system directories.

```
$cat /etc/fstab
/state/partition1/tmp                     /tmp                    none    defaults,bind   0 0
/state/partition1/var                     /var                    none    defaults,bind   0 0
```


