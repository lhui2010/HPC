#!/bin/bash

set -euxo pipefail

#Disable all queues
qmod -d \*; 

#Reschedule all jobs
qmod -rj \*; 

#Shutdown execution daemon (Optional)
qconf -kej all -km"

