#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="greybird-gtk-theme"
VERSION=3.22.6
DESCRIPTION="Desktop Suite for Xfce"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://github.com/shimmerproject/Greybird/archive/v3.22.6.tar.gz
TARBALL="$NAME-$VERSION.tar.gz"

wget -c $URL -O $TARBALL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
