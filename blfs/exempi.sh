#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Exempi is an implementation of XMPbr3ak (Adobe's Extensible Metadata Platform).br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:boost
#REQ:valgrind


#VER:exempi:2.3.0


NAME="exempi"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exempi/exempi-2.3.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exempi/exempi-2.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exempi/exempi-2.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exempi/exempi-2.3.0.tar.bz2 || wget -nc http://libopenraw.freedesktop.org/download/exempi-2.3.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exempi/exempi-2.3.0.tar.bz2


URL=http://libopenraw.freedesktop.org/download/exempi-2.3.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST