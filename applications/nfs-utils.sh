#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The NFS Utilities package containsbr3ak the userspace server and client tools necessary to use the kernel'sbr3ak NFS abilities. NFS is a protocol that allows sharing file systemsbr3ak over the network.br3ak"
SECTION="basicnet"
VERSION=1.3.4
NAME="nfs-utils"

#REQ:libtirpc
#REQ:rpcbind
#OPT:libevent
#OPT:sqlite
#OPT:libnfsidmap
#OPT:mitkrb
#OPT:libcap


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/nfs/nfs-utils-1.3.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://downloads.sourceforge.net/nfs/nfs-utils-1.3.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if ! grep nogroup /etc/group &>/dev/null; then groupadd -g 99 nogroup; fi
if ! grep nobody /etc/passwd &>/dev/null; then useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup -s /bin/false -u 99 nobody; fi
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --without-tcp-wrappers \
            --disable-nfsv4        \
            --disable-gss &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod u+w,go+r /sbin/mount.nfs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2
tar xf blfs-systemd-units-20160602.tar.bz2
cd blfs-systemd-units-20160602
make install-nfs-client

cd ..
rm -rf blfs-systemd-units-20160602
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
