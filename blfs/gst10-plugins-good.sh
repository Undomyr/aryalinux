#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The GStreamer Good Plug-ins is abr3ak set of plug-ins considered by the GStreamer developers to have good qualitybr3ak code, correct functionality, and the preferred license (LGPL forbr3ak the plug-in code, LGPL or LGPL-compatible for the supportingbr3ak library). A wide range of video and audio decoders, encoders, andbr3ak filters are included.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:gst10-plugins-base
#REC:cairo
#REC:flac
#REC:gdk-pixbuf
#REC:libjpeg
#REC:libpng
#REC:libsoup
#REC:libvpx
#REC:x7lib
#OPT:aalib
#OPT:alsa-oss
#OPT:gtk3
#OPT:gtk-doc
#OPT:libdv
#OPT:libgudev
#OPT:pulseaudio
#OPT:speex
#OPT:taglib
#OPT:valgrind
#OPT:v4l-utils


#VER:gst-plugins-good:1.8.3


NAME="gst10-plugins-good"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz


URL=http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --with-package-name="GStreamer Good Plugins 1.8.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
