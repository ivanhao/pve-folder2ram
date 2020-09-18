#!/bin/bash

main(){
   apt -y install  wget
   wget -O /sbin/folder2ram https://raw.githubusercontent.com/bobafetthotmail/folder2ram/master/debian_package/sbin/folder2ram
   chmod +x /sbin/folder2ram
   mkdir /etc/folder2ram
   
echo -e "tmpfs\t\t/var/log" > /etc/folder2ram/folder2ram.conf
echo -e "tmpfs\t\t/var/tmp" >> /etc/folder2ram/folder2ram.conf
echo -e "tmpfs\t\t/var/cache" >> /etc/folder2ram/folder2ram.conf
echo -e "tmpfs\t\t/tmp" >> /etc/folder2ram/folder2ram.conf


   folder2ram -enablesystemd
   
   folder2ram -mountall
   
   cat << EOF > /usr/bin/truncLog
#!/bin/bash

isFile(){
        L=\`cat \$1|wc -l\`
        n=\$((\$L - 300))
        if [ \$n -gt 0 ];then
                sed -i "1,\${n}d" \$1
        fi
}

isDir(){
        echo \$1
        for i in \`ls \$1\`
        do
                if [ -f \$1/\$i ];then
                        isFile \$1/\$i
                else
                        isDir \$1/\$i
                fi
        done
}
rm /var/log/*.gz
for i in {1..6}
do
   rm /var/log/*.\$i
done
isDir '/var/log'
EOF

    chmod +x /usr/bin/truncLog
    echo "" >> /etc/crontab
    echo "@reboot */10  *	*	*	*	root	/usr/bin/truncLog" >> /etc/crontab
    systemctl restart cron
    echo "done."
}

echo "install pve-folder2ram? (y\n)"
read x
if [ $x == 'y' ];then
    main
else
    exit
fi
