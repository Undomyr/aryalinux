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
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://downloads.sourceforge.net/nfs/nfs-utils-1.3.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if ! grep nogroup /etc/group &>/dev/null; then groupadd -g 99 nogroup; fi
if ! grep nobody /etc/passwd &>/dev/null; then useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup -s /bin/false -u 99 nobody; fi
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 99 nogroup &&
useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    -s /bin/false -u 99 nobody

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
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
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/home <em class="replaceable"><code>192.168.0.0/24</em>(rw,subtree_check,anonuid=99,anongid=99)

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-nfsv4-server

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-nfs-server

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
<em class="replaceable"><code><server-name></em>:/home  /home nfs   rw,_netdev 0 0
<em class="replaceable"><code><server-name></em>:/usr   /usr  nfs   ro,_netdev 0 0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-nfs-client

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
