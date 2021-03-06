#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libsysstat package contains abr3ak library used to query system info and statistics.br3ak"
SECTION="lxqt"
VERSION=0.3.3
NAME="libsysstat"

#REQ:cmake
#REQ:lxqt-build-tools
#REQ:qt5


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/libsysstat/0.3.3/libsysstat-0.3.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://downloads.lxqt.org/libsysstat/0.3.3/libsysstat-0.3.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsysstat/libsysstat-0.3.3.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
