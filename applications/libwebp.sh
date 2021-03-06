#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libwebp package contains abr3ak library and support programs to encode and decode images in WebPbr3ak format.br3ak"
SECTION="general"
VERSION=0.5.1
NAME="libwebp"

#REC:libjpeg
#REC:libpng
#REC:libtiff
#OPT:freeglut
#OPT:giflib


cd $SOURCE_DIR

URL=http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz

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

./configure --prefix=/usr           \
            --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
