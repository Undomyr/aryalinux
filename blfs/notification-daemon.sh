#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#VER:notification-daemon:3.20.0

#REQ:gtk3
#REQ:libcanberra


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "notification-daemon=>`date`" | sudo tee -a $INSTALLED_LIST

