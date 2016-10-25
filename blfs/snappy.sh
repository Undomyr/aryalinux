#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="snappy"
URL=http://pkgs.fedoraproject.org/repo/pkgs/snappy/snappy-1.0.5.tar.gz/4c0af044e654f5983f4acbf00d1ac236/snappy-1.0.5.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
