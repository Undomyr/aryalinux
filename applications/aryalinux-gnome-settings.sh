#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-gnome-settings"
VERSION=2017.08
DESCRIPTION="Fonts of the aryalinux XFCE and Mate Desktops"

cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux-gnome-defaults.tar.gz
wget -nc $URL

sudo tar xf aryalinux-gnome-defaults.tar.gz -C /
cp -r /etc/skel/.config ~
cp -r /etc/skel/.bash* ~

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
