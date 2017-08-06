#!/bin/ksh

export TEMPDIR=/tmp/openbsd
export SKELDIR=$(pwd)/skel

mkdir -p ${TEMPDIR}/
echo "skel-dir: ${SKELDIR}"

cp ${SKELDIR}/.* ${TEMPDIR}/root/
cp ${SKELDIR}/* ${TEMPDIR}/root/

if [[ -f /etc/pkg.conf ]] ; then
	# OpenBSD 6.0 and older
	cp /etc/pkg.conf ${TEMPDIR}/etc/
fi

if [[ -f /etc/installurl ]] ; then
	cp /etc/installurl ${TEMPDIR}/etc/
fi


echo "nameserver 8.8.8.8" > ${TEMPDIR}/etc/resolv.conf

chroot ${TEMPDIR} pkg_add -l /root/list


