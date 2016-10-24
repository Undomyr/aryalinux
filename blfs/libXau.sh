#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libXau package contains abr3ak library implementing the X11 Authorization Protocol. This is usefulbr3ak for restricting client access to the display.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:x7proto


#VER:libXau:1.0.8


NAME="libXau"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libXau/libXau-1.0.8.tar.bz2


URL=http://ftp.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
