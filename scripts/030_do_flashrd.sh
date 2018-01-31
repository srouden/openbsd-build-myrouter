#!/bin/ksh

if [ ! -f ../TARGET.sub ] ; then
	echo "../TARGET.sub not found"
	exit 1
fi
. ../TARGET.sub

if [ x"${CLEAN_OBJ}" == "xyes" ]; then
	echo "remove objects"
	unset DESTDIR
	rm -rf /usr/obj/*
fi

cd ${FLASHRD_DIR}
flashrd_opt=""
if [ "x${DISKSECTORS}" != "x" ] ; then
  flashrd_opt="-l $DISKSECTORS"
fi
if [ "x${IMAGEDIR}" != "x" ] ; then
  flashrd_opt="$flashrd_opt -i $IMAGEDIR"
else
  IMAGEDIR=$FLASHRD_DIR   # Avoiding later ugly if statement
fi

c ./flashrd $flashrd_opt $TEMPDIR

echo "flashrd image built in $IMAGEDIR"
echo "$0 done"
