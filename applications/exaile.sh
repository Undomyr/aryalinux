#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="exaile"
VERSION="4.0.0"

NAME="exaile"

#OPT:gstreamer-0.10
#OPT:gstreamer-0.10-plugins-base
#OPT:gstreamer-0.10-plugins-good
#OPT:gstreamer-0.10-plugins-bad
#OPT:gstreamer-0.10-plugins-ugly
#OPT:gstreamer-0.10-ffmpeg
#REQ:mutagen
#OPT:gstreamer-0.10-python
#REQ:db
#REQ:python-modules#bsddb3

cd $SOURCE_DIR
URL="https://github.com/exaile/exaile/archive/4.0.0-beta2.tar.gz"
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed -i "s@/usr/local@/usr@g" Makefile
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
