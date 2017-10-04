#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="greybird-gtk-theme"
VERSION=1.0
DESCRIPTION="Desktop Suite for Xfce"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.09/bin/greybird-gtk-theme.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

wget -nc $URL
sudo tar xf $TARBALL -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
