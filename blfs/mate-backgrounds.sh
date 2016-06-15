#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:mate-backgrounds:1.12.0

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.12/mate-backgrounds-1.12.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "mate-backgrounds=>`date`" | sudo tee -a $INSTALLED_LIST