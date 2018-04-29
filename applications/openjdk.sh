#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak OpenJDK is an open-sourcebr3ak implementation of Oracle's Java Standard Edition platform.br3ak OpenJDK is useful for developingbr3ak Java programs, and provides abr3ak complete runtime environment to run Java programs.br3ak"
SECTION="general"
VERSION=9.0.4+11
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
#REC:make-ca
#REC:giflib
#REC:lcms2
#REC:libjpeg
#REC:libpng
#REC:wget
#OPT:mercurial
#OPT:twm


cd $SOURCE_DIR

URL=http://hg.openjdk.java.net/jdk-updates/jdk9u/archive/jdk-9.0.4+11.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://hg.openjdk.java.net/jdk-updates/jdk9u/archive/jdk-9.0.4+11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk-9.0.4+11.tar.bz2
wget -nc https://ci.adoptopenjdk.net/view/all/job/jtreg/lastSuccessfulBuild/artifact/jtreg-4.2-b12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b12.tar.gz

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
dbc62e27a93686a9aea12e9c97c2f765  corba.tar.bz2
25853ba33123397b2e755249f102ae73  hotspot.tar.bz2
f5ab5e468565e1ab3a181d2efb45b51f  jaxp.tar.bz2
520ff49cb470fbcec2f46cbb3fdb377d  jaxws.tar.bz2
be9f261b19451ab1300c5842188e3fe2  jdk.tar.bz2
22b65322d04c8ffafd77230dbe5f178f  langtools.tar.bz2
729d03b0cede2f697ad77170a9d89095  nashorn.tar.bz2
EOF
for subproject in corba hotspot jaxp jaxws jdk langtools nashorn; do
  wget -c http://hg.openjdk.java.net/jdk-updates/jdk9u/${subproject}/archive/jdk-9.0.4+11.tar.bz2 \
       -O ${subproject}.tar.bz2
done &&
md5sum -c subprojects.md5 &&
for subproject in corba hotspot jaxp jaxws jdk langtools nashorn; do
  mkdir -pv ${subproject} &&
  tar -xf ${subproject}.tar.bz2 --strip-components=1 -C ${subproject}
done


tar -xf ../jtreg-4.2-b12.tar.gz


unset JAVA_HOME                             &&
bash configure --enable-unlimited-crypto    \
               --disable-warnings-as-errors \
               --with-stdc++lib=dynamic     \
               --with-giflib=system         \
               --with-jtreg=$PWD/jtreg      \
               --with-lcms=system           \
               --with-libjpeg=system        \
               --with-libpng=system         \
               --with-zlib=system           \
               --with-version-build="11"    \
               --with-version-pre=""        \
               --with-version-opt=""        \
               --with-cacerts-file=/etc/ssl/java/cacerts.jks &&
make images



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/jdk-9.0.4+11             &&
cp -Rv build/*/images/jdk/* /opt/jdk-9.0.4+11 &&
chown -R root:root /opt/jdk-9.0.4+11          &&
find /opt/jdk-9.0.4+11 -name \*.diz -delete   &&
for s in 16 24 32 48; do
  install -Dm 644 jdk/src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/java9.png
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -nsf jdk-9.0.4+11 /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
cat > /usr/share/applications/openjdk-9-java.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java 9 Runtime
Comment=OpenJDK Java 9 Runtime
Exec=/opt/jdk/bin/java -jar
Terminal=false
Type=Application
Icon=java9
MimeType=application/x-java-archive;application/java-archive;application/x-jar;
NoDisplay=true
EOF
cat > /usr/share/applications/openjdk-9-policytool.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java 9 Policy Tool
Name[pt_BR]=OpenJDK Java 9 - Ferramenta de Pol�tica
Comment=OpenJDK Java 9 Policy Tool
Comment[pt_BR]=OpenJDK Java 9 - Ferramenta de Pol�tica
Exec=/opt/jdk/bin/policytool
Terminal=false
Type=Application
Icon=java9
Categories=Settings;
EOF
cat > /usr/share/applications/openjdk-9-jconsole.desktop << "EOF"
[Desktop Entry]
Name=OpenJDK Java 9 Console
Comment=OpenJDK Java 9 Console
Keywords=java;console;monotoring
Exec=/opt/jdk/bin/jconsole
Terminal=false
Type=Application
Icon=java9
Categories=Application;System;
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/usr/sbin/make-ca --force &&
ln -sfv /etc/ssl/java/cacerts.jks /opt/jdk/lib/security/cacerts

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
