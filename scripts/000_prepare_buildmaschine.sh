#!/bin/ksh
WDIR=`pwd`
RELEASE=""
if [ -f $0 ]; then
	. ../TARGET.sub
	cd ../openbsd-build-tools/
else
	echo "please run script in scripts folder"
	exit 1
fi

if [ x"$RELEASE" == "x" ] ; then
	echo "no RELEASE define, check TARGET.sub"
	exit 1
fi

./build_openbsd.py --cvs_tag $RELEASE --update_cvs
./build_openbsd.py --cvs_tag $RELEASE --build kernel --kernel GENERIC.MP
./build_openbsd.py --cvs_tag $RELEASE --build userland
./build_openbsd.py --cvs_tag $RELEASE --build release

cd WDIR
