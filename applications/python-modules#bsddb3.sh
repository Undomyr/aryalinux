#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="python-modules#bsddb3"
VERSION="6.1.1"

#REQ:db

cd $SOURCE_DIR
URL=https://pypi.python.org/packages/95/1c/e8fb33007192f30b9a7276560c3c16499ab2a2c08abc59141b84e1afd3a9/bsddb3-6.1.1.tar.gz
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py --berkeley-db=/usr build
sudo python setup.py install

#python3 setup.py build
#sudo python3 setup.py install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
