#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libvorbis
#REQ:libtheora
#REQ:libogg
#REQ:flac
#REQ:sdl
#REQ:jack2
#REQ:libexif
#REQ:pulseaudio
#REQ:libxml2
#REQ:alsa-lib
#REQ:xserver-meta
#REQ:mesa
#REQ:glu
#REQ:gobject-introspection
#REQ:glib2
#REQ:frei0r
#REQ:libsox2
#REQ:libjack0
#REQ:swh-plugins
#REQ:eigen3


cd $SOURCE_DIR

URL="https://github.com/mltframework/shotcut/releases/download/v17.06/shotcut-linux-x86_64-170601.tar.bz2"
wget -nc $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

sudo tar xf $TARBALL -C /opt
sudo ln -svf /opt/Shotcut/Shotcut.desktop /usr/share/applications/
sudo update-desktop-database

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
