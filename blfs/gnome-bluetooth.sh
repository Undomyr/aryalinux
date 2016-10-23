#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Bluetooth packagebr3ak contains tools for managing and manipulating Bluetooth devicesbr3ak using the GNOME Desktop.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gtk3
#REQ:itstool
#REQ:libcanberra
#REC:gobject-introspection
#OPT:gtk-doc
#OPT:bluez
#OPT:systemd


#VER:gnome-bluetooth:3.20.0


NAME="gnome-bluetooth"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST