#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Opal package contains a C++br3ak class library for normalising the numerous telephony protocols intobr3ak a single integrated call model.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:ptlib
#OPT:ffmpeg
#OPT:libtheora
#OPT:openjdk
#OPT:ruby
#OPT:speex
#OPT:x264


#VER:opal:3.10.10


NAME="opal"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opal/opal-3.10.10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/opal-3.10.10-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/opal/opal-3.10.10-ffmpeg2-1.patch


URL=http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../opal-3.10.10-ffmpeg2-1.patch &&
sed -e 's/CODEC_ID/AV_&/' \
    -e 's/PIX_FMT_/AV_&/' \
    -i plugins/video/H.263-1998/h263-1998.cxx \
       plugins/video/common/dyna.cxx          \
       plugins/video/H.264/h264-x264.cxx      \
       plugins/video/MPEG4-ffmpeg/mpeg4.cxx   &&
sed -e '/<< mime.PrintContents/ s/mime/(const std::string\&)&/' \
    -i src/im/msrp.cxx  &&
./configure --prefix=/usr &&
CXXFLAGS=-Wno-deprecated-declarations make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 644 /usr/lib/libopal_s.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
