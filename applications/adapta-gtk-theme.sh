#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION=""

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/adapta-gtk-theme.tar.xz

sudo tar xf adapta-gtk-theme.tar.xz -C /usr/share/themes/

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
