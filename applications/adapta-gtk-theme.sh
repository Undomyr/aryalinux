#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION="3.93.1.18"

#REQ:gtk2
#REQ:gtk3
#REQ:sassc

URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/adapta-gtk-theme.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

cd $SOURCE_DIR

wget -nc $URL

sudo tar xf $TARBALL -C /

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
