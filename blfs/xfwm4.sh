#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xfwm4:4.12.3

#REQ:libwnck2
#REQ:libxfce4ui
#REQ:libxfce4util
#REC:startup-notification


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/xfwm4/4.12/xfwm4-4.12.3.tar.bz2

wget -nc http://archive.xfce.org/src/xfce/xfwm4/4.12/xfwm4-4.12.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfwm4/xfwm4-4.12.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfwm4/xfwm4-4.12.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfwm4/xfwm4-4.12.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfwm4/xfwm4-4.12.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfwm4/xfwm4-4.12.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xfwm4=>`date`" | sudo tee -a $INSTALLED_LIST
