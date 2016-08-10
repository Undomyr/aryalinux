#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lximage-qt:0.4.0

#REQ:libexif
#REQ:pcmanfm-qt


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lximage-qt/0.4.0/lximage-qt-0.4.0.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.4.0.tar.xz || wget -nc http://downloads.lxqt.org/lximage-qt/0.4.0/lximage-qt-0.4.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.4.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lximage-qt/lximage-qt-0.4.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.4.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lximage-qt/lximage-qt-0.4.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/1%/%1/' src/translations/lximage-qt_pt_BR.ts &&
sed -i 's/Utility;//' data/lximage-qt.desktop.in       &&
mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      ..       &&
LIBRARY_PATH=/opt/qt5/lib:$LXQT_PREFIX/lib make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf $LXQT_PREFIX/share/applications/lximage-qt.desktop \
        /usr/share/applications &&
ln -svf $LXQT_PREFIX/share/applications/lximage-qt-screenshot.desktop \
        /usr/share/applications

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "lximage-qt=>`date`" | sudo tee -a $INSTALLED_LIST

