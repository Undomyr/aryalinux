#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak QtWebEngine integratesbr3ak chromium\"s web capabilities intobr3ak Qt. It ships with its own copy of <a class=\"xref\" href=\"../general/ninja.html\" title=\"Ninja-1.7.2\">Ninja-1.7.2</a> whichbr3ak it uses for the build, and various copies of libraries from ffmpeg,br3ak icu, libvpx, and zlib (including libminizip) which have been forkedbr3ak by the chromium developers.br3ak"
SECTION="x"
VERSION=5.9.1
NAME="qtwebengine"

#REQ:nss
#REQ:pulseaudio
#REQ:qt5
#REC:libwebp
#REC:libxslt
#REC:opus
#REC:rust
#OPT:libevent


cd $SOURCE_DIR

URL=https://download.qt.io/archive/qt/5.9/5.9.1/submodules/qtwebengine-opensource-src-5.9.1.tar.xz

if [ ! -z $URL ]
then
wget -nc https://download.qt.io/archive/qt/5.9/5.9.1/submodules/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebengine/qtwebengine-opensource-src-5.9.1.tar.xz

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

mkdir build &&
cd    build &&
qmake ..    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/qt5/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
