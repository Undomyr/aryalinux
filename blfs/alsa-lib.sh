#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The ALSA Library package containsbr3ak the ALSA library used by programs (including ALSA Utilities) requiring access to the ALSAbr3ak sound interface.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:doxygen
#OPT:python2


#VER:alsa-lib:1.1.2


NAME="alsa-lib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-lib/alsa-lib-1.1.2.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.2.tar.bz2 || wget -nc http://alsa.cybermirror.org/lib/alsa-lib-1.1.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-1.1.2.tar.bz2


URL=http://alsa.cybermirror.org/lib/alsa-lib-1.1.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure &&
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
