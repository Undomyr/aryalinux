#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Screen is a terminal multiplexorbr3ak that runs several separate processes, typically interactive shells,br3ak on a single physical character-based terminal. Each virtualbr3ak terminal emulates a DEC VT100 plus several ANSI X3.64 and ISO 2022br3ak functions and also provides configurable input and outputbr3ak translation, serial port support, configurable logging, multi-userbr3ak support, and many character encodings, including UTF-8. Screenbr3ak sessions can be detached and resumed later on a different terminal.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:linux-pam


#VER:screen:4.4.0


NAME="screen"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/screen/screen-4.4.0.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz || wget -nc https://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz


URL=https://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                     \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc &&
sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -m 644 etc/etcscreenrc /etc/screenrc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST