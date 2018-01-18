#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION="3.93.0.56"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/1.0/adapta-gtk-theme.tar.xz

wget -nc $URL

sudo tar xf adapta-gtk-theme.tar.xz -C /usr/share/themes/

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
