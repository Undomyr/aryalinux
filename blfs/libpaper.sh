#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This package is intended to provide a simple way for applicationsbr3ak to take actions based on a system or user-specified paper size.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:libpaper_1.1.2+nmu:4


NAME="libpaper"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.debian.org/debian/pool/main/libp/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc ftp://ftp.debian.org/debian/pool/main/libp/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpaper/libpaper_1.1.24+nmu4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpaper/libpaper_1.1.24+nmu4.tar.gz


URL=http://ftp.debian.org/debian/pool/main/libp/libpaper/libpaper_1.1.24+nmu4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -vp /etc/libpaper.d &&
cat > /usr/bin/run-parts << "EOF"
#!/bin/sh
# run-parts:  Runs all the scripts found in a directory.
# from Slackware, by Patrick J. Volkerding with ideas borrowed
# from the Red Hat and Debian versions of this utility.
# keep going when something fails
set +e
if [ $# -lt 1 ]; then
  echo "Usage: run-parts <directory>"
  exit 1
fi
if [ ! -d $1 ]; then
  echo "Not a directory: $1"
  echo "Usage: run-parts <directory>"
  exit 1
fi
# There are several types of files that we would like to
# ignore automatically, as they are likely to be backups
# of other scripts:
IGNORE_SUFFIXES="~ ^ , .bak .new .rpmsave .rpmorig .rpmnew .swp"
# Main loop:
for SCRIPT in $1/* ; do
  # If this is not a regular file, skip it:
  if [ ! -f $SCRIPT ]; then
    continue
  fi
  # Determine if this file should be skipped by suffix:
  SKIP=false
  for SUFFIX in $IGNORE_SUFFIXES ; do
    if [ ! "$(basename $SCRIPT $SUFFIX)" = "$(basename $SCRIPT)" ]; then
      SKIP=true
      break
    fi
  done
  if [ "$SKIP" = "true" ]; then
    continue
  fi
  # If we've made it this far, then run the script if it's executable:
  if [ -x $SCRIPT ]; then
    $SCRIPT || echo "$SCRIPT failed."
  fi
done
exit 0
EOF
chmod -v 755 /usr/bin/run-parts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/papersize << "EOF"
a4
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST