#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="arc-gtk-theme"
VERSION=1.0
DESCRIPTION="Arc is a flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell which supports GTK 3 and GTK 2 based desktop environments like Gnome, Unity, Budgie, Pantheon, XFCE, Mate, etc"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR
URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.09/bin/arc-gtk-theme.tar.xz
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

sudo tar xf $TARBALL -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
