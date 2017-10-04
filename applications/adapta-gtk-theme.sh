#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION="1.0"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.09/bin/adapta-gtk-theme.tar.xz

wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

sudo tar xf $TARBALL -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
