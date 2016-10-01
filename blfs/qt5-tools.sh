#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qt5-tools:5.6.1

#REQ:qt5


cd $SOURCE_DIR

URL=http://archive.ubuntu.com/ubuntu/pool/universe/q/qttools-opensource-src/qttools-opensource-src_5.6.1.orig.tar.xz

wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

qmake &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sudo make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qt5-tools=>`date`" | sudo tee -a $INSTALLED_LIST

