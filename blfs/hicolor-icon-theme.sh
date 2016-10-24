#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The hicolor-icon-theme packagebr3ak contains a default fallback theme for implementations of the iconbr3ak theme specification.br3ak
#SECTION:x

whoami > /tmp/currentuser



#VER:hicolor-icon-theme:0.15


NAME="hicolor-icon-theme"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz || wget -nc http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hicolor-icon-theme/hicolor-icon-theme-0.15.tar.xz


URL=http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
