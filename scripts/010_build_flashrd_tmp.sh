#!/bin/ksh
. ../TARGET.sub
echo $RELEASEDIR
if [ x"$RELEASEDIR" == "x" ] ; then
	echo "no RELEASEDIR define, check TARGET.sub"
	exit 1
fi

R=${RELEASEDIR}
TEMPDIR=/tmp/openbsd

test -d ${TEMPDIR} && mv ${TEMPDIR} ${TEMPDIR}.old && rm -rf ${TEMPDIR}.old &
sleep 10

mkdir -p ${TEMPDIR}
cd ${TEMPDIR}
echo `pwd`

tar xzpf $R/base$VER.tgz
tar xzpf $R/man$VER.tgz
tar xzpf $R/comp$VER.tgz
tar xzpf $R/game$VER.tgz
if [ -f ./var/sysmerge/etc.tgz ]; then
	tar xzpf ./var/sysmerge/etc.tgz 
elif [ -f ./usr/share/sysmerge/etc.tgz ]; then
	tar xzpf ./usr/share/sysmerge/etc.tgz 
fi
echo done.
echo go to $TEMPDIR
