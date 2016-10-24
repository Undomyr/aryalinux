#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The JSON-C implements a referencebr3ak counting object model that allows you to easily construct JSONbr3ak objects in C, output them as JSON formatted strings and parse JSONbr3ak formatted strings back into the C representation of JSON objects.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:json-c:0.12.1


NAME="json-c"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz


URL=https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i s/-Werror// Makefile.in tests/Makefile.in &&
./configure --prefix=/usr --disable-static       &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
