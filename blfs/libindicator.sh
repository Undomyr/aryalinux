#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libindicator:0.5.0

cd $SOURCE_DIR

URL="https://launchpad.net/libindicator/0.5/0.5.0/+download/libindicator-0.5.0.tar.gz"
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

echo "libindicator=>`date`" | sudo tee -a $INSTALLED_LIST