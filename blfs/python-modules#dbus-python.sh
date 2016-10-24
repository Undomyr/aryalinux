#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:%DESCRIPTION%
#SECTION:general

whoami > /tmp/currentuser

#REQ:dbus-glib
#REQ:python2
#REQ:python3


#VER:dbus-python:1.2.4


NAME="python-modules#dbus-python"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dbus-python/dbus-python-1.2.4.tar.gz


URL=http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir python2 &&
pushd python2 &&
PYTHON=/usr/bin/python     \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.4 &&
make &&
popd

mkdir python3 &&
pushd python3 &&
PYTHON=/usr/bin/python3    \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.4 &&
make &&
popd


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python2 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
