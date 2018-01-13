#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Rust programming language isbr3ak designed to be a safe, concurrent, practical language.br3ak"
SECTION="general"
VERSION=1.19.0
NAME="rust"

#REQ:curl
#REQ:cmake
#REQ:python2
#OPT:gdb
#OPT:ninja


cd $SOURCE_DIR

URL=https://static.rust-lang.org/dist/rustc-1.19.0-src.tar.gz

if [ ! -z $URL ]
then
wget -nc https://static.rust-lang.org/dist/rustc-1.19.0-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rustc/rustc-1.19.0-src.tar.gz

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

cat <<EOF > config.toml
# see src/bootstrap/config.toml.example for more possible options
[llvm]
targets = "X86"
[build]
# install cargo as well as rust
extended = true
[install]
prefix = "/usr"
docdir = "share/doc/rustc-1.19.0"
channel = "stable"
EOF


./x.py build



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./x.py install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
