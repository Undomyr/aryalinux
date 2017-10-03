#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="flat-remix-icon-theme"
VERSION=SVN
DESCRIPTION="Flat Remix is a flat icon theme for Linux"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.08/Flat-Remix.tar.xz
sudo tar xf Flat-Remix.tar.xz -C /

cd $SOURCE_DIR

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
