#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="kde"
NAME="krameworks5"

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:openssl10
#REQ:qtwebkit5
#REQ:phonon
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt
#OPT:bluez
#OPT:ModemManager
#OPT:TTF-and-OTF-fonts#oxygen-fonts
#OPT:TTF-and-OTF-fonts#noto-fonts
#OPT:doxygen
#OPT:python-modules#Jinja2
#OPT:python-modules#PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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

url=http://download.kde.org/stable/frameworks/5.41/
wget -r -nH -nd -A '*.xz' -np $url


cat > frameworks-5.41.0.md5 << "EOF"
1ebbd6b7636cbc463a3d5413c2e32a73 attica-5.41.0.tar.xz
#6ec01cba580d3ef21d84f7255e6a1dac extra-cmake-modules-5.41.0.tar.xz
eb1a924ff44e4ca3d0c1aebadf98dd2e kapidox-5.41.0.tar.xz
4552b6cee31f42f9d6746ebbbe8d65c9 karchive-5.41.0.tar.xz
b7332e685615a6d730558044faa82c37 kcodecs-5.41.0.tar.xz
ca16ea0465784e8cae48fcfd383ade22 kconfig-5.41.0.tar.xz
2de35d8c776f0510ec83e8aa91706613 kcoreaddons-5.41.0.tar.xz
82b2f634646b701268f2e8ed18a1c393 kdbusaddons-5.41.0.tar.xz
f3c68c3f4f635cba8bd541365968fa19 kdnssd-5.41.0.tar.xz
68ff5c6e23100fbcb8e5df810c8446dd kguiaddons-5.41.0.tar.xz
d232ea154a69d7bd81ddbb4238dd14b9 ki18n-5.41.0.tar.xz
4f0b0fbecc626761a4afdef751e3945b kidletime-5.41.0.tar.xz
55ea32eabc52b698ed9732daf913481c kimageformats-5.41.0.tar.xz
c16c33b4e37dd61a1b6102e4dfa4084c kitemmodels-5.41.0.tar.xz
0712c43b59fb63227bbe4649bd3069aa kitemviews-5.41.0.tar.xz
cfa7e31be126bab9514367529ee388e8 kplotting-5.41.0.tar.xz
36a55709d9232754de87fce845af407e kwidgetsaddons-5.41.0.tar.xz
c37711fc60fba6f59e3d12202615384b kwindowsystem-5.41.0.tar.xz
8fe93eb125b593ca324a7f9c5ffc35f2 networkmanager-qt-5.41.0.tar.xz
f3903da2459a5f6b2915a9ea20791811 solid-5.41.0.tar.xz
f39210f1a1d609dc5ab91b81eab7496c sonnet-5.41.0.tar.xz
08710d126dd5e9295f6d2082e1c715ba threadweaver-5.41.0.tar.xz
4e2206fb13c1f7ecfc6ff8fdba3b6755 kauth-5.41.0.tar.xz
4dfd9f0b601b3b29fda431e67749d84b kcompletion-5.41.0.tar.xz
f31bdd55610016116304a7c2895267cc kcrash-5.41.0.tar.xz
b3674a19a7c16bee9f020645e0ddbc55 kdoctools-5.41.0.tar.xz
5bd431ca01ea01478089b1ae9e96248f kpty-5.41.0.tar.xz
870fbc616eeddace047a97cc49709826 kunitconversion-5.41.0.tar.xz
0a9f9185b73c61ff98d866b347cb84ab kconfigwidgets-5.41.0.tar.xz
ac350a079c779228290d8ad6f7d95424 kservice-5.41.0.tar.xz
4c6269c4428df1e6f590619cb4c4ff79 kglobalaccel-5.41.0.tar.xz
e5bbc196ebb357071988c1a5bf660de2 kpackage-5.41.0.tar.xz
1d03482ad18b4fcf5efdc08342dad0fd kdesu-5.41.0.tar.xz
ae76e8c76beb51f43bbe2adb71f9ed2e kemoticons-5.41.0.tar.xz
11d64047d571925ec70b6b2774e2f7e6 kiconthemes-5.41.0.tar.xz
a933f40379454c722fcc6748d02b1fa5 kjobwidgets-5.41.0.tar.xz
ebd60e338a9e7b59a555a5d3cc0d7b5a knotifications-5.41.0.tar.xz
b0f13d0727924a002fb3da6ba51b9b5e ktextwidgets-5.41.0.tar.xz
280907ea04c30f4d8ccf780e01061537 kxmlgui-5.41.0.tar.xz
436243672adfe56567c732d97924adba kbookmarks-5.41.0.tar.xz
894a257850904ba73491d33f77570dba kwallet-5.41.0.tar.xz
4249f48518556c174f9475e3f33ca3e1 kio-5.41.0.tar.xz
88160137086a2b01d97bcd13d0175cc1 kdeclarative-5.41.0.tar.xz
8e1f8ac1320b01c9f894eb4ae22452ae kcmutils-5.41.0.tar.xz
cbfb3f5b2135551975d9e204a18a1011 kirigami2-5.41.0.tar.xz
e3ecbab2d0aef7ab54137dd10f260199 knewstuff-5.41.0.tar.xz
0dd6f089983ecd32155a980dd701d8bd frameworkintegration-5.41.0.tar.xz
f1be560698aaa8329f61cc364208becd kinit-5.41.0.tar.xz
d3a25384ba8bc72c34adc23431bfb1fc knotifyconfig-5.41.0.tar.xz
c799742b700dc63cc29b43b05363caf6 kparts-5.41.0.tar.xz
94b470c2ab31754cec8b976dbcf914fb kactivities-5.41.0.tar.xz
55e4ea83c260ed6133d91baa85e83ee2 kded-5.41.0.tar.xz
e6ca0e267d398418221b44686eeb8112 kdewebkit-5.41.0.tar.xz
fc593a8fbb7ad9105d3f5cbab20025f9 syntax-highlighting-5.41.0.tar.xz
4a56a69a8d4180bed8e0fc62b104ae5b ktexteditor-5.41.0.tar.xz
4e68fcc75c98efbb52ad10cc93f94cac kdesignerplugin-5.41.0.tar.xz
182714e5cffb3f8d98cd9ec9e5e342a2 kwayland-5.41.0.tar.xz
a824f972b674747dcf4c37b72ac5aafe plasma-framework-5.41.0.tar.xz
d9f1c4a923b48fc6f27317be8d880279 modemmanager-qt-5.41.0.tar.xz
d2fcacdd586ea9523dfdced3508a9018 kpeople-5.41.0.tar.xz
fe298ffdfee126f9ba3bcdef1118fcdf kxmlrpcclient-5.41.0.tar.xz
c1be30ad443b482cb64be7ec294e643d bluez-qt-5.41.0.tar.xz
2a0ca3328b99e0107a4037319747c079 kfilemetadata-5.41.0.tar.xz
b7636f757203dc0c31bcebb9c43d82f4 baloo-5.41.0.tar.xz
#4d9130ec475e1a99d44cddc3be5c0965 breeze-icons-5.41.0.tar.xz
#b55b649450dcffe2b207e203915f8985 oxygen-icons5-5.41.0.tar.xz
98dfb00d6d376b9adaa45f28444cdc74 kactivities-stats-5.41.0.tar.xz
3eb823010cc1738302e3f0e89c088f62 krunner-5.41.0.tar.xz
#c8f1ba624b752249fba8a590b9c67f4a prison-5.41.0.tar.xz
ca0658e0f314b957dae151c83f4f24db qqc2-desktop-style-5.41.0.tar.xz
50cf974dae417f0ba8785fd64ed186ab kjs-5.41.0.tar.xz
d1dad42422f484912a1b32eee1344436 kdelibs4support-5.41.0.tar.xz
795c5ae86722acf4153ad77f9dcde6f6 khtml-5.41.0.tar.xz
dcae4f0b65f53a64b4c6296fbe03be97 kjsembed-5.41.0.tar.xz
6bcc75b0773b2dbcc73a3e9db0e95efc kmediaplayer-5.41.0.tar.xz
b58a7bdf8cc70e20293fad45990f8876 kross-5.41.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5.old                         &&
install -v -dm755           /opt/kf5/{etc,share} &&
ln -sfv /etc/dbus-1         /opt/kf5/etc         &&
ln -sfv /usr/share/dbus-1   /opt/kf5/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


bash -e


export CXXFLAGS='-isystem /usr/include/openssl-1.0'
while read -r line; do
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    tar -xf $file
    pushd $packagedir
      case $packagedir in
        kdelibs4support*)
          sed -i.orig \
             '/OPENSSL_FOUND/i set(OPENSSL_INCLUDE_DIR "/usr/include/openssl-1.0")' \
             src/CMakeLists.txt
        ;;
      esac
      mkdir build
      cd    build
      cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
            -DCMAKE_PREFIX_PATH=/opt/qt5        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make "-j`nproc`" || make
      as_root make install
  popd
  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
done < frameworks-5.41.0.md5
exit



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5-5.41.0
ln -sfvn kf5-5.41.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
