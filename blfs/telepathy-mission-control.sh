#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Telepathy Mission Control is anbr3ak account manager and channel dispatcher for the Telepathy framework, allowing user interfacesbr3ak and other clients to share connections to real-time communicationbr3ak services without conflicting.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:telepathy-glib
#REC:networkmanager
#OPT:gtk-doc
#OPT:upower


#VER:telepathy-mission-control:5.16.4


NAME="telepathy-mission-control"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz


URL=http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz
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