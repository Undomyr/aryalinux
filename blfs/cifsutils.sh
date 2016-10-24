#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The cifs-utils provides a meansbr3ak for mounting SMB/CIFS shares on a Linux system.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#OPT:keyutils
#OPT:linux-pam
#OPT:mitkrb
#OPT:talloc
#OPT:samba
#OPT:libcap


#VER:cifs-utils:6.6


NAME="cifsutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.6.tar.bz2


URL=https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.6.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-pam &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
