#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="Python bindings for wxWidgets"
NAME="wxpython"
VERSION="3.0.2"

#REQ:wxwidgets

cd $SOURCE_DIR

URL=https://sources.voidlinux.eu/wxPython-3.0.2.0/wxPython-src-3.0.2.0.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY
cd wxPython

export CC="gcc"
export CXX="g++"

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
