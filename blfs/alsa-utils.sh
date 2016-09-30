#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:alsa-utils:1.1.2

#REQ:alsa-lib
#OPT:libsamplerate
#OPT:xmlto


cd $SOURCE_DIR

URL=http://alsa.cybermirror.org/utils/alsa-utils-1.1.2.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-utils/alsa-utils-1.1.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.2.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-utils/alsa-utils-1.1.2.tar.bz2 || wget -nc http://alsa.cybermirror.org/utils/alsa-utils-1.1.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --disable-alsaconf \
            --disable-bat   \
            --disable-xmlto \
            --with-curses=ncursesw &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
alsactl -L store

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G audio `cat /tmp/currentuser`



cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "alsa-utils=>`date`" | sudo tee -a $INSTALLED_LIST

