#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:sass
#REQ:inkscape

NAME=libsass
DESCRIPTION="A C/C++ implementation of a Sass compiler"
VERSION=3.4.9

URL=https://github.com/sass/libsass/releases/download/3.4.9/libsass-3.4.9.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

autoreconf --force --install
./configure --prefix=/usr --enable-shared &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf libsass-3.4.9

echo "libsass=>$(date)" | sudo tee -a /etc/alps/installed-list
echo "libsass:$VERSION" | sudo tee -a /etc/alps/versions
