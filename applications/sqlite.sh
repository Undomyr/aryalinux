#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The SQLite package is a softwarebr3ak library that implements a self-contained, serverless,br3ak zero-configuration, 
transactional SQL database engine.br3ak"
SECTION="server"
VERSION=3210000
NAME="sqlite"

#OPT:unzip


cd $SOURCE_DIR

URL=https://sqlite.org/2017/sqlite-autoconf-3210000.tar.gz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc https://sqlite.org/2017/sqlite-doc-3210000.zip

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

unzip -q ../sqlite-doc-3210000.zip

./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts5     \
            CFLAGS="-g -O2                    \
            -DSQLITE_ENABLE_FTS4=1            \
            -DSQLITE_ENABLE_COLUMN_METADATA=1 \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
            -DSQLITE_SECURE_DELETE=1          \
            -DSQLITE_ENABLE_FTS3_TOKENIZER=1" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/sqlite-3.21.0 &&
cp -v -R sqlite-doc-3210000/* /usr/share/doc/sqlite-3.21.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
