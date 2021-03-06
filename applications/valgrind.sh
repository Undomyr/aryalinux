#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Valgrind is an instrumentationbr3ak framework for building dynamic analysis tools. There are Valgrindbr3ak tools that can automatically detect many memory management andbr3ak threading bugs, and profile programs in detail. Valgrind can alsobr3ak be used to build new tools.br3ak"
SECTION="general"
VERSION=3.12.0
NAME="valgrind"

#OPT:boost
#OPT:llvm
#OPT:gdb
#OPT:general_which
#OPT:bind
#OPT:bind-utils
#OPT:libxslt
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://valgrind.org/downloads/valgrind-3.12.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2 || wget -nc http://valgrind.org/downloads/valgrind-3.12.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.12.0.tar.bz2

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

sed -i 's|/doc/valgrind||' docs/Makefile.in &&
./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.12.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
