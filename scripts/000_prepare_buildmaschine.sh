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
	echo "no RELEASE defined, check TARGET.sub"
	exit 1
fi

if ! userinfo -e build ; then
  echo "User 'build' must exist"
  exit 1
fi

if ! groupinfo -e wobj ; then
  echo "Group 'wobj' must exist"
  exit 1
fi

if [ $VER -ge "60" ] ; then
  # Check the release directory for correct owner and permission
  if [ -d $RELEASEDIR ] ; then
          release_perm=`ls -ld $RELEASEDIR | awk -F' ' '{print $1":"$3}'`
          if [ x"$release_perm" != "xdrwx------:build" ] ; then
                  ls -ld $RELEASEDIR
                  echo "$RELEASEDIR must have owner 'build' and permission 700"
                  exit 1
          fi
          rel_dev=`df -P $RELEASEDIR | tail -1 | cut -f1 -d' '`
          echo "$RELEASEDIR is on $rel_dev"
          mount | egrep "^${rel_dev}" | grep -qw noperm
          status=$?
          if [ $status -ne 0 ] ; then
                  mount | egrep "^${rel_dev}"
                  echo "$RELEASEDIR must be mounted with 'noperm'"
                  exit 1
          fi
  else
          echo "$RELEASEDIR must exist and"
          echo "be mounted with 'noperm' and"
          echo "owned by user 'build' with permissions 700"
          exit 1
  fi
else
  if [ ! -d $RELEASEDIR ] ; then
    echo "$RELEASEDIR not found, creating"
    mkdir -p $RELEASEDIR
  fi
  # DESTDIR?
fi

c ./build_openbsd.py --cvs_tag $RELEASE --update_cvs
c ./build_openbsd.py --cvs_tag $RELEASE --build kernel --kernel GENERIC.MP
c ./build_openbsd.py --cvs_tag $RELEASE --build userland
c ./build_openbsd.py --cvs_tag $RELEASE --build release

echo "OpenBSD $RELEASE built"
echo "$0 done"
cd $WDIR
