#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Talloc provides a hierarchical,br3ak reference counted memory pool system with destructors. It is thebr3ak core memory allocator used in Samba.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:python2
#OPT:python3


#VER:talloc:2.1.8


NAME="talloc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.8.tar.gz || wget -nc https://www.samba.org/ftp/talloc/talloc-2.1.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/talloc/talloc-2.1.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.8.tar.gz


URL=https://www.samba.org/ftp/talloc/talloc-2.1.8.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST