#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak Mercurial is a distributed sourcebr3ak control management tool similar to Git and Bazaar. Mercurial is written in Python and is used by projects such as Mozillabr3ak and Vim.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:python2
#OPT:git
#OPT:gnupg
#OPT:subversion


#VER:mercurial:3.9.2


NAME="mercurial"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://www.mercurial-scm.org/release/mercurial-3.9.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-3.9.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-3.9.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mercurial/mercurial-3.9.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mercurial/mercurial-3.9.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mercurial/mercurial-3.9.2.tar.gz


URL=https://www.mercurial-scm.org/release/mercurial-3.9.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make build


make doc


rm -rf tests/tmp &&
TESTFLAGS="-j<em class="replaceable"><code><N></em> --tmpdir tmp --blacklist blacklists/failed-tests" \
make check



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install-doc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.hgrc << "EOF"
[ui]
username = <em class="replaceable"><code><user_name> <user@mail></em>
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /etc/mercurial &&
cat >> /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
