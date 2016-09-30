#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:highlight:3.31

#REQ:boost
#REQ:lua
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.andre-simon.de/zip/highlight-3.31.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/highlight/highlight-3.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/highlight/highlight-3.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/highlight/highlight-3.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/highlight/highlight-3.31.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/highlight/highlight-3.31.tar.bz2 || wget -nc http://www.andre-simon.de/zip/highlight-3.31.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "highlight=>`date`" | sudo tee -a $INSTALLED_LIST

