#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:Jinja2:2.8

cd $SOURCE_DIR

URL="https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "jinja2=>`date`" | sudo tee -a $INSTALLED_LIST

