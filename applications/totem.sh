#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:audio-video-plugins
#REQ:totem-pl-parser

NAME=totem
VERSION=3.24.0
DESCRIPTION="Totem is a gstreamer based video player for gnome desktop environment"

cd $SOURCE_DIR

URL="https://download.gnome.org/sources/totem/3.24/totem-3.24.0.tar.xz"
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
