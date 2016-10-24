#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak Pango is a library for laying outbr3ak and rendering of text, with an emphasis on internationalization. Itbr3ak can be used anywhere that text layout is needed, though most of thebr3ak work on Pango so far has been donebr3ak in the context of the GTK+ widgetbr3ak toolkit.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:fontconfig
#REQ:freetype2
#REQ:harfbuzz
#REQ:glib2
#REC:cairo
#REC:x7lib
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:pango:1.40.3


NAME="pango"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pango/pango-1.40.3.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
