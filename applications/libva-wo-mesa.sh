#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="libva-wo-mesa"
VERSION="2.1.0"

#REQ:libdrm
#OPT:doxygen
#REQ:wayland

cd $SOURCE_DIR

URL=https://github.com/intel/libva/releases/download/2.1.0/libva-2.1.0.tar.bz2

wget -nc $URL
wget -nc https://github.com/intel/intel-vaapi-driver/releases/download/2.1.0/intel-vaapi-driver-2.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh

cd $SOURCE_DIR

tar xf intel-vaapi-driver-2.1.0.tar.bz2
cd intel-vaapi-driver-2.1.0
./configure $XORG_CONFIG &&
make
sudo make install
cd $SOURCE_DIR
sudo rm -rf intel-vaapi-driver-2.1.0

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
