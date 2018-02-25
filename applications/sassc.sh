#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=sassc
DESCRIPTION="libsass command line driver"
VERSION=3.4.8

URL=https://github.com/sass/sassc/releases/download/3.4.8/sassc-3.4.8.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autoreconf --force --install
./configure --prefix=/usr --enable-shared &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf libsass-3.4.9

echo "sassc=>$(date)" | sudo tee -a /etc/alps/installed-list
echo "sassc:$VERSION" | sudo tee -a /etc/alps/versions
