#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak OpenJDK is an open-sourcebr3ak implementation of Oracle's Java Standard Edition platform.br3ak OpenJDK is useful for developingbr3ak Java programs, and provides abr3ak complete runtime environment to run Java programs.br3ak"
SECTION="general"
VERSION=15
NAME="openjdk"

#REQ:java
#REQ:ojdk-conf
#REQ:alsa-lib
#REQ:cpio
#REQ:cups
#REQ:unzip
#REQ:general_which
#REQ:x7lib
#REQ:zip
#REC:cacerts
#REC:giflib
#REC:wget
#OPT:mercurial
#OPT:twm


cd $SOURCE_DIR

URL=http://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u141-b15.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u141-b15.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk8u141-b15.tar.bz2
wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.141/jtreg-4.2-b08-891.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b08-891.tar.gz
wget -nc http://icedtea.classpath.org/download/source/icedtea-web-1.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.7.tar.gz

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

cat > subprojects.md5 << EOF &&
4061c0f2dc553cf92847e4a39a03ea4e  corba.tar.bz2
269a0fde90b9ab5ca19fa82bdb3d6485  hotspot.tar.bz2
a1dfcd15119dd10db6e91dc2019f14e7  jaxp.tar.bz2
16f904d990cb6a3c84ebb81bd6bea1e7  jaxws.tar.bz2
4fb652cdd6fee5f2873b00404e9a01f3  langtools.tar.bz2
c4a99c9c5293bb5c174366664843c8ce  jdk.tar.bz2
c2f06cd8d6e90f3dcc57bec53f419afe  nashorn.tar.bz2
EOF
for subproject in corba hotspot jaxp jaxws langtools jdk nashorn; do
  wget -c http://hg.openjdk.java.net/jdk8u/jdk8u/${subproject}/archive/jdk8u141-b15.tar.bz2 \
       -O ${subproject}.tar.bz2
done &&
md5sum -c subprojects.md5 &&
for subproject in corba hotspot jaxp jaxws langtools jdk nashorn; do
  mkdir -pv ${subproject} &&
  tar -xf ${subproject}.tar.bz2 --strip-components=1 -C ${subproject}
done


tar -xf ../jtreg-4.2-b08-891.tar.gz


unset JAVA_HOME               &&
sh ./configure                \
   --with-update-version=141  \
   --with-build-number=b15    \
   --with-milestone=BLFS      \
   --enable-unlimited-crypto  \
   --with-zlib=system         \
   --with-giflib=system       \
   --with-extra-cflags="-std=c++98 -Wno-error -fno-delete-null-pointer-checks -fno-lifetime-dse" \
   --with-extra-cxxflags="-std=c++98 -fno-delete-null-pointer-checks -fno-lifetime-dse" &&
make DEBUG_BINARIES=true SCTP_WERROR= all  &&
find build/*/images/j2sdk-image -iname \*.diz -delete


if [ -n "$DISPLAY" ]; then
  OLD_DISP=$DISPLAY
fi
export DISPLAY=:20
nohup Xvfb $DISPLAY                              \
           -fbdir $(pwd)                         \
           -pixdepths 8 16 24 32 > Xvfb.out 2>&1 &
echo $! > Xvfb.pid
echo Waiting for Xvfb to initialize; sleep 1
nohup twm -display $DISPLAY \
          -f /dev/null > twm.out 2>&1            &
echo $! > twm.pid
echo Waiting for twm to initialize; sleep 1
xhost +


echo -e "
jdk_all = :jdk_core           \\
          :jdk_svc            \\
          :jdk_beans          \\
          :jdk_imageio        \\
          :jdk_sound          \\
          :jdk_sctp           \\
          com/sun/awt         \\
          javax/accessibility \\
          javax/print         \\
          sun/pisces          \\
          com/sun/java/swing" >> jdk/test/TEST.groups &&
sed -e 's/all:.*jck.*/all: jtreg/'      \
    -e '/^JTREG /s@\$(JT_PLATFORM)/@@'  \
    -i langtools/test/Makefile


JT_JAVA=$(type -p javac | sed 's@/bin.*@@') &&
JT_HOME=$(pwd)/jtreg                        &&
PRODUCT_HOME=$(echo $(pwd)/build/*/images/j2sdk-image)


LANG=C make -k -C test                       \
            JT_HOME=${JT_HOME}               \
            JT_JAVA=${JT_JAVA}               \
            PRODUCT_HOME=${PRODUCT_HOME} all || true
LANG=C ${JT_HOME}/bin/jtreg -a -v:fail,error \
                -dir:$(pwd)/hotspot/test     \
                -k:\!ignore                  \
                -jdk:${PRODUCT_HOME}         \
                :jdk || true


kill -9 `cat twm.pid`  &&
kill -9 `cat Xvfb.pid` &&
rm -f Xvfb.out twm.out &&
rm -f Xvfb.pid twm.pid &&
if [ -n "$OLD_DISP" ]; then
  DISPLAY=$OLD_DISP
fi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -RT build/*/images/j2sdk-image /opt/OpenJDK-1.8.0.141 &&
chown -R root:root /opt/OpenJDK-1.8.0.141

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -nsf OpenJDK-1.8.0.141 /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../icedtea-web-1.7.tar.gz  \
        icedtea-web-1.7/javaws.png \
        --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
cat > /usr/share/applications/openjdk-8-policytool.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java Policy Tool
Name[pt_BR]=OpenJDK Java - Ferramenta de Pol�tica
Comment=OpenJDK Java Policy Tool
Comment[pt_BR]=OpenJDK Java - Ferramenta de Pol�tica
Exec=/opt/jdk/bin/policytool
Terminal=false
Type=Application
Icon=javaws
Categories=Settings;
EOF
install -v -Dm0644 javaws.png /usr/share/pixmaps/javaws.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfv /etc/ssl/java/cacerts /opt/jdk/jre/lib/security/cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /opt/jdk
bin/keytool -list -keystore /etc/ssl/java/cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
