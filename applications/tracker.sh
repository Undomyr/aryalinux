#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Tracker is the file indexing andbr3ak search provider used in the GNOMEbr3ak desktop environment.br3ak"
SECTION="gnome"
VERSION=2.0.2
NAME="tracker"

#REQ:json-glib
#REQ:libseccomp
#REQ:libsoup
#REQ:python2
#REQ:vala
#REC:icu
#REC:networkmanager
#REC:sqlite
#REC:upower
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/tracker/2.0/tracker-2.0.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/tracker/2.0/tracker-2.0.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tracker/tracker-2.0.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/tracker/2.0/tracker-2.0.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-session-bus-services-dir=/usr/share/dbus-1/services &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"