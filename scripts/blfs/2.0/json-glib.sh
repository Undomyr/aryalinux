#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.2.tar.xz


TARBALL=json-glib-1.0.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998758.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998758.sh
sudo ./1434987998758.sh
sudo rm -rf 1434987998758.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "json-glib=>`date`" | sudo tee -a $INSTALLED_LIST