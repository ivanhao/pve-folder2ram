#!/bin/bash

echo "uninstalling ..."
#echo "uninstall pve-folder2ram? (y\n)"
#read x
#if [ $x == 'y' ];then
   folder2ram -syncall
   folder2ram -umountall
   folder2ram -disablesystemd
   
   sed -i '/truncLog/d' /etc/crontab
   systemctl restart cron
   echo "done."
#else
#    exit
#fi
