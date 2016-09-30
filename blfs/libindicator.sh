#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL="https://launchpad.net/libindicator/12.10/12.10.1/+download/libindicator-12.10.1.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sed '/-Werror/s/$/ -Wno-deprecated-declarations/' -i libindicator/Makefile.{am,in}
sed 's/LIBINDICATOR_LIBS+="$LIBM"/LIBINDICATOR_LIBS+=" $LIBM"/g' -i configure
sed 's/LIBM="-lmw"/LIBM=" -lmw"/g' -i configure
sed 's/LIBM="-lm"/LIBM=" -lm"/g' -i configure
sed 's/LIBS="-lm  $LIBS"/LIBS=" -lm  $LIBS"/g' -i configure
sed 's/LIBS="-lmw $LIBS"/LIBS=" -lmw $LIBS"/g' -i configure

./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--libexecdir=/usr/lib/$name \
	--disable-static \
	--with-gtk=2 &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libindicator=>`date`" | sudo tee -a $INSTALLED_LIST
