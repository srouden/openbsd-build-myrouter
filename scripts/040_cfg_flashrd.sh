#!/bin/ksh

if [ ! -f ../TARGET.sub ] ; then
	echo "../TARGET.sub not found"
	exit 1
fi

. ../TARGET.sub

if [ ! -d $FLASHRD_DIR ] ; then
	echo "$FLASHRD_DIR not found"
	exit 1
fi

if [ "x${IMAGEDIR}" = "x" ] ; then
  IMAGEDIR=$FLASHRD_DIR
fi

imagefile=`find ${IMAGEDIR} -type f -iname flashimg\* | head -n 1`
cd ${FLASHRD_DIR}

[ -f $SKELDIR/onetime.tgz ] && onetime="-o $SKELDIR/onetime.tgz"

c ./cfgflashrd -image $imagefile \
	-c $baudrate \
	-t $tzfile \
	-k $keyboard \
	$onetime \
	-dns $nameserver \
	-ntp $ntpserver \
	-hostname $myhostname

echo "flashrd image $imagefile configured"
echo "$0 done"
