#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Firefox is a stand-alone browser based on the Mozilla codebase."
SECTION="xsoft"
VERSION=57.0.4
NAME="firefox"

#REQ:alsa-lib
#REQ:autoconf213
#REQ:gtk3
#REQ:gtk2
#REQ:nss
#REQ:unzip
#REQ:yasm
#REQ:zip
#REQ:dbus-glib
#REQ:GConf
#REQ:ffmpeg
#REQ:libwebp
#REQ:pulseaudio
#REQ:startup-notification
#REQ:valgrind
#REQ:liboauth
#REQ:graphite2
#REC:icu
#REC:libevent
#REC:libvpx
#REC:sqlite
#REQ:rust
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:GConf
#OPT:ffmpeg
#OPT:libwebp
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:valgrind
#OPT:wget
#OPT:wireless_tools
#OPT:liboauth
#OPT:graphite2
#OPT:harfbuzz


cd $SOURCE_DIR

URL=https://ftp.mozilla.org/pub/firefox/releases/$VERSION/source/firefox-$VERSION.source.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/firefox-$VERSION-system_graphite2_harfbuzz-1.patch

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

export SHELL=/bin/sh

cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# You can change the number of non-rust jobs by setting a valid number
# of cores in this option, but when rust crates are being compiled
# jobs will be scheduled for all the online CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"

# If you have installed dbus-glib, comment out this line:
ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
#ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocaton API
# (needed for use with saved maps with Google Maps)
#ac_add_options --with-google-api-keyfile=$PWD/google-key

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# If you have installed GConf, comment out this line
ac_add_options --disable-gconf

# Stylo is the new CSS code, including the rust 'style'
# package. It is enabled by default but requires clang.
# Uncomment this if you do not wish to use stylo.
#ac_add_options --disable-stylo

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu

# If you are going to apply the patch for system graphite
# and system harfbuzz, uncomment these lines:
#ac_add_options --with-system-graphite2
#ac_add_options --with-system-harfbuzz

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser

ac_add_options --enable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# Optimization for size is broken with gcc7
ac_add_options --enable-optimize="-O2"

ac_add_options --enable-official-branding

# From firefox-40, using system cairo caused firefox to crash
# frequently when it was doing background rendering in a tab.
# This appears to again work in firefox-56
ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-pthreads

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF

patch -Np1 -i ../firefox-57.0.4-system_graphite2_harfbuzz-1.patch
export SHELL=/bin/sh

export BINDGEN_CFLAGS=$(pkg-config --cflags nspr pixman-1) &&
make -f client.mk                                          &&
unset BINDGEN_CFLAGS

sudo make -f client.mk install INSTALL_SDK= &&
sudo chown -R 0:0 /usr/lib/firefox-$VERSION   &&

sudo mkdir -pv    /usr/lib/mozilla/plugins  &&
sudo ln    -sfv   ../../mozilla/plugins /usr/lib/firefox-$VERSION/browser


sudo mkdir -pv /usr/share/applications &&
sudo mkdir -pv /usr/share/pixmaps &&
sudo tee /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
sudo ln -sfv /usr/lib/firefox-$VERSION/browser/icons/mozicon128.png \
        /usr/share/pixmaps/firefox.png


# Create package...

make -f client.mk install INSTALL_SDK= DESTDIR=$BINARY_DIR/firefox-$VERSION-$(uname -m) &&
sudo chown -R 0:0 $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/lib/firefox-$VERSION   &&
sudo mkdir -pv    $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/lib/mozilla/plugins  &&
sudo ln    -sfv   ../../mozilla/plugins $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/lib/firefox-$VERSION/browser

sudo mkdir -pv $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/share/applications &&
sudo mkdir -pv $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/share/pixmaps &&
sudo tee $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
sudo ln -sfv /usr/lib/firefox-$VERSION/browser/icons/mozicon128.png \
        $BINARY_DIR/firefox-$VERSION-$(uname -m)/usr/share/pixmaps/firefox.png
pushd $BINARY_DIR/firefox-$VERSION-$(uname -m)
sudo tar -cJvf ../firefox-$VERSION-$(uname -m).tar.xz *
popd
sudo rm -r $BINARY_DIR/firefox-$VERSION-$(uname -m)

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
