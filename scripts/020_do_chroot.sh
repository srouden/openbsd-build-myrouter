#!/bin/ksh

if [ ! -f ../TARGET.sub ] ; then
	echo "../TARGET.sub not found"
	exit 1
fi
. ../TARGET.sub

ONETIME=${SKELDIR}/onetime

if [ ! -d $TEMPDIR -o ! -d ${TEMPDIR}/etc -o ! -d ${TEMPDIR}/root ] ; then
	echo "${TEMPDIR} not properly populated. Aborting."
	exit 1
fi

if [ "x${SKELDIR}" != "x" -a -d ${SKELDIR} ] ; then
	echo "skel-dir: ${SKELDIR}"

	find $SKELDIR \( -type f -a \! -name \*onetime\* \) -o \( -path skel/onetime -prune \! -type d \) | xargs -rtIxx cp xx ${TEMPDIR}/root
fi

if [[ -f /etc/pkg.conf ]] ; then
	# OpenBSD 6.0 and older
	cp /etc/pkg.conf ${TEMPDIR}/etc/
fi

if [[ -f /etc/installurl ]] ; then
	cp /etc/installurl ${TEMPDIR}/etc/
fi

if [ -d $ONETIME ] ; then
	[ ! -d ${ONETIME}/etc ] && mkdir ${ONETIME}/etc

	# resolv.conf
	if [ ! -f ${ONETIME}/etc/resolv.conf ] ; then
		if [ "x$mydomain" != "x" ] ; then
			echo "search ${mydomain}" > ${ONETIME}/etc/resolv.conf
		fi
		if [ "x$nameserver" != "x" ] ; then
			for ns in $nameserver ; do
				echo "nameserver $ns" >> ${ONETIME}/etc/resolv.conf
			done
		fi
	fi

	(cd $ONETIME ; tar cf ../onetime.tgz .)
fi

if [ ! -f ${TEMPDIR}/etc/resolv.conf -a -f ${ONETIME}/etc/resolv.conf ] ; then
	cp ${ONETIME}/etc/resolv.conf ${TEMPDIR}/etc
else
	# If all else fails use googles ns
	echo "nameserver 8.8.8.8" >> ${TEMPDIR}/etc/resolv.conf
fi

chroot ${TEMPDIR} pkg_add -l /root/list

# Postprocess package setup
if [ -d pkgsetup ] ; then
	for f in pkgsetup/*.sh ; do
		echo $f
		$f
	done
fi

echo "OpenBSD configured in $TEMPDIR"
echo "$0 done"
