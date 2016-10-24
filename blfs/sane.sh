#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak SANE is short for Scanner Accessbr3ak Now Easy. Scanner access; however, is far from easy, since everybr3ak vendor has their own protocols. The only known protocol that shouldbr3ak bring some unity into this chaos is the TWAIN interface, but thisbr3ak is too imprecise to allow a stable scanning framework. Therefore,br3ak SANE comes with its own protocol,br3ak and the vendor drivers can't be used.br3ak
#SECTION:pst

whoami > /tmp/currentuser

#OPT:avahi
#OPT:cups
#OPT:libjpeg
#OPT:libtiff
#OPT:libusb
#OPT:v4l-utils
#OPT:texlive
#OPT:tl-installer
#OPT:gtk2
#OPT:gimp
#OPT:xorg-server


#VER:sane-frontends:1.0.14
#VER:sane-backends:1.0.25


NAME="sane"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sane-backends/sane-backends-1.0.25.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc ftp://ftp2.sane-project.org/pub/sane/sane-frontends-1.0.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://alioth.debian.org/frs/download.php/file/1140/sane-frontends-1.0.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sane-frontends/sane-frontends-1.0.14.tar.gz


URL=http://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /var/lock
mkdir -pv /var/lock/
touch /var/lock/sane
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if ! grep scanner /etc/group; then groupadd -g 70 scanner; fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G scanner `cat /tmp/currentuser`



./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --with-group=scanner \
            --with-docdir=/usr/share/doc/sane-backend-1.0.25 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                         &&
install -m 644 -v tools/udev/libsane.rules           \
                  /etc/udev/rules.d/65-scanner.rules &&
chgrp -v scanner  /var/lock/sane

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
