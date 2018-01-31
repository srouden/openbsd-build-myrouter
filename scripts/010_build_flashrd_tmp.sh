#!/bin/ksh
if [ ! -f ../TARGET.sub ] ; then
	echo "../TARGET.sub not found"
	exit 1
fi
. ../TARGET.sub
echo $RELEASEDIR
if [ x"$RELEASEDIR" == "x" ] ; then
	echo "no RELEASEDIR define, check TARGET.sub"
	exit 1
fi

R=${RELEASEDIR}/release

test -d ${TEMPDIR} && mv ${TEMPDIR} ${TEMPDIR}.old && rm -rf ${TEMPDIR}.old &
sleep 10

mkdir -p ${TEMPDIR}
cd ${TEMPDIR}
echo `pwd`

c tar xzpf $R/base$VER.tgz
c tar xzpf $R/man$VER.tgz
c tar xzpf $R/comp$VER.tgz
c tar xzpf $R/game$VER.tgz
if [ -f ./var/sysmerge/etc.tgz ]; then
	tar xzpf ./var/sysmerge/etc.tgz 
elif [ -f ./usr/share/sysmerge/etc.tgz ]; then
	tar xzpf ./usr/share/sysmerge/etc.tgz 
fi
echo "OpenBSD installed in $TEMPDIR"
echo $0 done.
echo go to $TEMPDIR
