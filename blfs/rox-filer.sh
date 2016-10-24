#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak rox-filer is a fast, lightweight,br3ak gtk2 file manager.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:libglade
#REQ:shared-mime-info


#VER:rox-filer:2.11


NAME="rox-filer"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/rox/rox-filer-2.11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rox-filer/rox-filer-2.11.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rox-filer/rox-filer-2.11.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rox-filer/rox-filer-2.11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rox-filer/rox-filer-2.11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rox-filer/rox-filer-2.11.tar.bz2


URL=http://downloads.sourceforge.net/rox/rox-filer-2.11.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd ROX-Filer                                                        &&
sed -i 's:g_strdup(getenv("APP_DIR")):"/usr/share/rox":' src/main.c &&
mkdir build                        &&
pushd build                        &&
  ../src/configure LIBS="-lm -ldl" &&
  make                             &&
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /usr/share/rox                              &&
cp -av Help Messages Options.xml ROX images style.css .DirIcon /usr/share/rox &&
cp -av ../rox.1 /usr/share/man/man1                  &&
cp -v  ROX-Filer /usr/bin/rox                        &&
chown -Rv root:root /usr/bin/rox /usr/share/rox      &&
cd /usr/share/rox/ROX/MIME                           &&
ln -sv text-x-{diff,patch}.png                       &&
ln -sv application-x-font-{afm,type1}.png            &&
ln -sv application-xml{,-dtd}.png                    &&
ln -sv application-xml{,-external-parsed-entity}.png &&
ln -sv application-{,rdf+}xml.png                    &&
ln -sv application-x{ml,-xbel}.png                   &&
ln -sv application-{x-shell,java}script.png          &&
ln -sv application-x-{bzip,xz}-compressed-tar.png    &&
ln -sv application-x-{bzip,lzma}-compressed-tar.png  &&
ln -sv application-x-{bzip-compressed-tar,lzo}.png   &&
ln -sv application-x-{bzip,xz}.png                   &&
ln -sv application-x-{gzip,lzma}.png                 &&
ln -sv application-{msword,rtf}.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > /path/to/hostname/AppRun << "HERE_DOC"
#!/bin/bash
MOUNT_PATH="${0%/*}"
HOST=${MOUNT_PATH##*/}
export MOUNT_PATH HOST
sshfs -o nonempty ${HOST}:/ ${MOUNT_PATH}
rox -x ${MOUNT_PATH}
HERE_DOC
chmod 755 /path/to/hostname/AppRun



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/bin/myumount << "HERE_DOC" &&
#!/bin/bash
sync
if mount | grep "${@}" | grep -q fuse
then fusermount -u "${@}"
else umount "${@}"
fi
HERE_DOC
chmod 755 /usr/bin/myumount

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -s ../rox/.DirIcon /usr/share/pixmaps/rox.png &&
mkdir -p /usr/share/applications &&
cat > /usr/share/applications/rox.desktop << "HERE_DOC"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Rox
Comment=The Rox File Manager
Icon=rox
Exec=rox
Categories=GTK;Utility;Application;System;Core;
StartupNotify=true
Terminal=false
HERE_DOC

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
