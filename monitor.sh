#!/bin/bash

cd /root/scripts
export SGE_ROOT=/opt/gridengine

while true
do 
    perl monitor.pl >monitor.log 2>monitor.err 
	sleep 1m
done
