#!/bin/ksh
DATE=`date +%Y%m%d`
FLASH=flashimg.i386-${DATE}
FDIR=`pwd`

vnddirs="root bin etc sbin usr"

case $1 in
	mount)
		if [ -f ${FDIR}/${FLASH} ]
		then
			echo is there
			vnconfig vnd0 ${FDIR}/${FLASH}
			mount /dev/vnd0a /mnt
		else
			echo "file is not there"
			exit 1
		fi
		mkdir /tmp/flashrd_upgrade
		cd /mnt
		cp bsd.mp bsd openbsd.vnd var.tar /tmp/flashrd_upgrade
		cd /tmp
	;;
	unmount)
		umount /mnt
		vnconfig -u vnd0
	;;
esac

