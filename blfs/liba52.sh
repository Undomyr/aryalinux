#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak liba52 is a free library forbr3ak decoding ATSC A/52 (also known as AC-3) streams. The A/52 standardbr3ak is used in a variety of applications, including digital televisionbr3ak and DVD.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:a52dec:0.7.4


NAME="liba52"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/a52dec/a52dec-0.7.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/a52dec/a52dec-0.7.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/a52dec/a52dec-0.7.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/a52dec/a52dec-0.7.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/a52dec/a52dec-0.7.4.tar.gz


URL=http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --enable-shared \
            --disable-static \
            CFLAGS="-g -O2 $([ $(uname -m) = x86_64 ] && echo -fPIC)" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp liba52/a52_internal.h /usr/include/a52dec &&
install -v -m644 -D doc/liba52.txt \
    /usr/share/doc/liba52-0.7.4/liba52.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST