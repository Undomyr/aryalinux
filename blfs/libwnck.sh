#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libwnck package contains thebr3ak Window Navigator Construction Kit.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gtk3
#REC:gobject-introspection
#REC:startup-notification
#OPT:gtk-doc


#VER:libwnck:3.20.1


NAME="libwnck"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libwnck/3.20/libwnck-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libwnck/3.20/libwnck-3.20.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-3.20.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-3.20.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwnck/libwnck-3.20.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libwnck/3.20/libwnck-3.20.1.tar.xz
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