#!/bin/sh
ls run_*.sh |  while read line 
do
./$line
done
