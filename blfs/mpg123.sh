#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The mpg123 package contains abr3ak console-based MP3 player. It claims to be the fastest MP3 decoderbr3ak for Unix.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REC:alsa-lib
#OPT:pulseaudio
#OPT:sdl


#VER:mpg123:1.23.8


NAME="mpg123"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/mpg123/mpg123-1.23.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mpg123/mpg123-1.23.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mpg123/mpg123-1.23.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.23.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mpg123/mpg123-1.23.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.23.8.tar.bz2


URL=http://downloads.sourceforge.net/mpg123/mpg123-1.23.8.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-module-suffix=.so &&
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
