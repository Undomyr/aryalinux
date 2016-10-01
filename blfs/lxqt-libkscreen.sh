#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libkscreen:5.7.3

#REQ:lxqt-kwayland


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.7.3/libkscreen-5.7.3.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://download.kde.org/stable/plasma/5.7.3/libkscreen-5.7.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "lxqt-libkscreen=>`date`" | sudo tee -a $INSTALLED_LIST
