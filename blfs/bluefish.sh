#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak Bluefish is a GTK+ text editor targeted towards programmersbr3ak and web designers, with many options to write websites, scripts andbr3ak programming code. Bluefishbr3ak supports many programming and markup languages, and it focuses onbr3ak editing dynamic and interactive websites.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:gtk3
#OPT:enchant
#OPT:gucharmap
#OPT:pcre


#VER:bluefish:2.2.9


NAME="bluefish"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.9.tar.bz2 || wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluefish/bluefish-2.2.9.tar.bz2


URL=http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.9.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.9 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
