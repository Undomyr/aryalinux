#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:kmod

URL=http://archive.ubuntu.com/ubuntu/pool/main/d/dkms/dkms_2.2.0.3.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "dkms=>`date`" | sudo tee -a $INSTALLED_LIST
