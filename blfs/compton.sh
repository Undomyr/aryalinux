#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
NAME="compton"
DESCRIPTION="A very lightweight desktop enviornment independent compositing manager"
VERSION="SVN-`date -I`"

#REQ:gtk2
#REQ:gtk3
#REQ:libconfig
#REQ:git

cd $SOURCE_DIR

git clone https://github.com/chjj/compton.git
cd compton
make
sudo make MANPAGES= install
mkdir -pv ~/.config
cp -v compton.sample.conf ~/.config/compton.conf

cd $SOURCE_DIR
rm -rf compton

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
