#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:reiserfsprogs:3.6.24



cd $SOURCE_DIR

URL=http://ftp.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.24/reiserfsprogs-3.6.24.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.24.tar.xz || wget -nc http://ftp.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.24/reiserfsprogs-3.6.24.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.24.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.24.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.24.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.24.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

CFLAGS="$CFLAGS -std=gnu89" \
./configure --prefix=/usr --sbindir=/sbin &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "reiserfs=>`date`" | sudo tee -a $INSTALLED_LIST
