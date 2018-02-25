#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="flat-remix-icon-theme"
VERSION=20180225
DESCRIPTION="Flat Remix is a flat icon theme for Linux"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://github.com/daniruiz/flat-remix/archive/20180225.tar.gz
TARBALL="$NAME-$VERSION.tar.gz"
wget -c $URL -O "$NAME-$VERSION.tar.gz"
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

sudo make install

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
