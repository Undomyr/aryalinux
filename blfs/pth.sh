#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pth:2.0.7



cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pth/pth-2.0.7.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pth/pth-2.0.7.tar.gz || wget -nc http://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pth/pth-2.0.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pth/pth-2.0.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pth/pth-2.0.7.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#$(LOBJS): Makefile#$(LOBJS): pth_p.h Makefile#' Makefile.in &&
./configure --prefix=/usr           \
            --disable-static        \
            --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/pth-2.0.7 &&
install -v -m644    README PORTING SUPPORT TESTS \
                    /usr/share/doc/pth-2.0.7

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pth=>`date`" | sudo tee -a $INSTALLED_LIST
