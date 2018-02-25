#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION="3.93.0.149"

#REQ:gtk2
#REQ:gtk3
#REQ:sassc

URL=https://github.com/adapta-project/adapta-gtk-theme/archive/3.93.0.149.tar.gz
TARBALL="adapta-gtk-theme-$VERSION.tar.gz"

cd $SOURCE_DIR

wget -c $URL -O $TARBALL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY
./autogen.sh --prefix=/usr
./configure --prefix=/usr --disable-parallel &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
