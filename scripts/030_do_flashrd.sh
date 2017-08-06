#!/bin/ksh
FLASHRD_DIR=../flashrd
echo "remove objects"
unset DESTDIR
rm -rf /usr/obj/*
cd ${FLASHRD_DIR}
./flashrd /tmp/openbsd
