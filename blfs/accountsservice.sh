#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The AccountsService packagebr3ak provides a set of D-Bus interfacesbr3ak for querying and manipulating user account information and anbr3ak implementation of those interfaces based on the usermod(8),br3ak useradd(8) and userdel(8) commands.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:polkit
#REC:gobject-introspection
#REC:systemd
#OPT:gtk-doc
#OPT:xmlto


#VER:accountsservice:0.6.43


NAME="accountsservice"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.43.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.43.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.43.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.43.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/accountsservice/accountsservice-0.6.43.tar.xz || wget -nc http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.43.tar.xz


URL=http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.43.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --enable-admin-group=adm \
            --disable-static         &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable accounts-daemon

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST