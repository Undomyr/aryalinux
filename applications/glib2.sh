#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GLib package containsbr3ak low-level libraries useful for providing data structure handlingbr3ak for C, portability wrappers and interfaces for such runtimebr3ak functionality as an event loop, threads, dynamic loading and anbr3ak object system.br3ak"
SECTION="general"
VERSION=2.54.3
NAME="glib2"

#REC:pcre
#OPT:dbus
#OPT:elfutils
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:shared-mime-info
#OPT:desktop-file-utils


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.54/glib-2.54.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.54/glib-2.54.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.54.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.54/glib-2.54.3.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/glib-2.54.3-meson_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/glib/glib-2.54.3-meson_fixes-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/glib-2.54.3-skip_warnings-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/glib/glib-2.54.3-skip_warnings-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../glib-2.54.3-skip_warnings-1.patch


patch -Np1 -i ../glib-2.54.3-meson_fixes-1.patch &&
mkdir build-glib &&
cd    build-glib &&
meson --prefix=/usr -Dwith-pcre=system -Dwith-docs=no .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install &&
chmod -v 755 /usr/bin/{gdbus-codegen,glib-gettextize} &&
mkdir -p /usr/share/doc/glib-2.54.3 &&
cp -r ../docs/reference/{NEWS,README,gio,glib,gobject} /usr/share/doc/glib-2.54.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
