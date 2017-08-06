#!/bin/ksh
FLASHRD_DIR=../flashrd
imagefile=`find ${FLASHRD_DIR} -type f -iname flashimg\* | head -n 1`
tzfile="/usr/share/zoneinfo/Europe/Berlin"
keyboard="de"
nameserver="8.8.8.8"
ntpserver="pool.ntp.org"
myhostname="r1.karstens.lan"

cd ${FLASHRD_DIR}

./cfgflashrd -image $imagefile \
	-c "38400" \
	-t $tzfile \
	-k $keyboard \
	-dns $nameserver \
	-ntp $ntpserver \
	-hostname $myhostname

