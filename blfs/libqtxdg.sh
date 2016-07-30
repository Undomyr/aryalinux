#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libqtxdg:1.3.0

#REQ:cmake
#REQ:qt5


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/libqtxdg/1.3.0/libqtxdg-1.3.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqtxdg/libqtxdg-1.3.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libqtxdg/libqtxdg-1.3.0.tar.xz || wget -nc http://downloads.lxqt.org/libqtxdg/1.3.0/libqtxdg-1.3.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqtxdg/libqtxdg-1.3.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libqtxdg/libqtxdg-1.3.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libqtxdg/libqtxdg-1.3.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "libqtxdg=>`date`" | sudo tee -a $INSTALLED_LIST

