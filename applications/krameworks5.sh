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

url=http://download.kde.org/stable/frameworks/5.37/
wget -r -nH -nd -A '*.xz' -np $url


cat > frameworks-5.37.0.md5 << "EOF"
b6c54ce0f87384c070e3dfb5488380c5 attica-5.37.0.tar.xz
#29883c1580c5b9e4c736a138fc832e1a extra-cmake-modules-5.37.0.tar.xz
d359828a8c026643374782268e099372 kapidox-5.37.0.tar.xz
141bf68d72d41056b1d1485da8a47a9e karchive-5.37.0.tar.xz
8d85c7e7e8fcafd111ee4926160c60e4 kcodecs-5.37.0.tar.xz
b25eebcac5447af9435f2effc2f566ce kconfig-5.37.0.tar.xz
76bf9525d2eebf95fbc4dde189b7dc74 kcoreaddons-5.37.0.tar.xz
2697c6440c566da94341f4bc3bf3164c kdbusaddons-5.37.0.tar.xz
e12d09fb176c0533d2a4eed6b43cbfc3 kdnssd-5.37.0.tar.xz
a395b2479d99128cba078c3a1299a566 kguiaddons-5.37.0.tar.xz
97bdebb717431b400add03d60484db72 ki18n-5.37.0.tar.xz
e070c69d7785532d0671a077e3cc370f kidletime-5.37.0.tar.xz
127c01934d68a3b3b88231e9602831e5 kimageformats-5.37.0.tar.xz
db88454a0c4335432055ac074104dc43 kitemmodels-5.37.0.tar.xz
062bfca05e8bb81fa8eb360c6944d75f kitemviews-5.37.0.tar.xz
12f507e62783ce6a17e61328b3a85b07 kplotting-5.37.0.tar.xz
70161280f8e10ac69fc7d334a8531fdd kwidgetsaddons-5.37.0.tar.xz
05864840b694d3a587590c38e2170df0 kwindowsystem-5.37.0.tar.xz
80523443bbb0a0882631f22793e7ff9c networkmanager-qt-5.37.0.tar.xz
edf069c6ea563318ae710a36d55af35a solid-5.37.0.tar.xz
3e2a53802d204bc73d975fd769cbdae2 sonnet-5.37.0.tar.xz
bd38a5cc79c9f2dc8e7f0fcf7df482c9 threadweaver-5.37.0.tar.xz
ed6136acf490dcdaa145e09f2f517338 kauth-5.37.0.tar.xz
b0efe7abac21241f3b5933c5b1ddb8ef kcompletion-5.37.0.tar.xz
34d013abaaae22b45a46956997b0b82c kcrash-5.37.0.tar.xz
fe3f523474c3e65a86884b3e88a18d2a kdoctools-5.37.0.tar.xz
c5732adada0f8ab44eaefbfd458351c4 kpty-5.37.0.tar.xz
6260f91d8340ab7505dbefd58cc7d3bf kunitconversion-5.37.0.tar.xz
e13440e05800f7187c7e98eb6babfa96 kconfigwidgets-5.37.0.tar.xz
d2d343de16c69c7b5d8c492fefa3115f kservice-5.37.0.tar.xz
36bf35d34827bb6b78c7b4cb8be3c554 kglobalaccel-5.37.0.tar.xz
b594e9d93bcfac2f6b2aa98f2642f9ca kpackage-5.37.0.tar.xz
d717f6061cac42035e133618bf043965 kdesu-5.37.0.tar.xz
cc5ff7c6f686c1278d56fcec5df38222 kemoticons-5.37.0.tar.xz
47babcad619664866c880623fd86ff2f kiconthemes-5.37.0.tar.xz
8c5f7d0160aadeb1392e44315bd3c706 kjobwidgets-5.37.0.tar.xz
b8fe7fc1e9180d7a2519d8401b42cd65 knotifications-5.37.0.tar.xz
deda1b1ac51fe9e4859bafb7c0144133 ktextwidgets-5.37.0.tar.xz
ef28a72da7beffaef6dfcaebcb509d30 kxmlgui-5.37.0.tar.xz
da82f6881e3b1de522b0ca6ce80c7634 kbookmarks-5.37.0.tar.xz
e5900cdfe4a4958965e25002b9f1cab8 kwallet-5.37.0.tar.xz
6d46bb8e26222e3c68a60611c62cd298 kio-5.37.0.tar.xz
6313ca5c3501ce1f4d00ceef3a441ced kdeclarative-5.37.0.tar.xz
d3a81d2cf8d4bcdcb8f1b4a018107e99 kcmutils-5.37.0.tar.xz
0b620a47aca20b155ae461e12a437ae5 knewstuff-5.37.0.tar.xz
5cb0433c25ace0fad2b49cf3b8459704 frameworkintegration-5.37.0.tar.xz
a931963d19b927560b5d81f4fb8bec12 kinit-5.37.0.tar.xz
10db039a62f903c42ddbe762fcef13b1 knotifyconfig-5.37.0.tar.xz
1fde7d6c99345e29d7c0a900a8c67659 kparts-5.37.0.tar.xz
53162e9c01be1e793e6407d2d3cde628 kactivities-5.37.0.tar.xz
ecff152277532d352cb2957a81c44300 kded-5.37.0.tar.xz
f24c53f5b36d23d24ca0b96f027051e0 kdewebkit-5.37.0.tar.xz
a6033d9a6240b133938602a4b7cb98d6 syntax-highlighting-5.37.0.tar.xz
b33dcff501812990fd3065a42264aca2 ktexteditor-5.37.0.tar.xz
2790a476fd712e9c9686a6ff151267dc kdesignerplugin-5.37.0.tar.xz
a1ebab3f95697555278c3bef60647647 kwayland-5.37.0.tar.xz
e73d212673dd92bfc4b943f9d1a21be4 plasma-framework-5.37.0.tar.xz
#b814194b5e8e03c04736567e178d1932 modemmanager-qt-5.37.0.tar.xz
06fbfd8fa30aace3d75fc156de5417d3 kpeople-5.37.0.tar.xz
8372393ce57eb14fb85e54602e24ae47 kxmlrpcclient-5.37.0.tar.xz
4eed8acd2acb2633cba4dd7f8a248b49 bluez-qt-5.37.0.tar.xz
438fe87d54d35f99a71a61cf3b8a9944 kfilemetadata-5.37.0.tar.xz
f317f652591702315c7a9f0d8f95031a baloo-5.37.0.tar.xz
#bf3a1386e6b3daf7b6ee27d59bd55a91 breeze-icons-5.37.0.tar.xz
#3f7cdadd2adc1b82b5600fbea90d0888 oxygen-icons5-5.37.0.tar.xz
18dcba6b6021a6ec21617816113b62fa kactivities-stats-5.37.0.tar.xz
ebac192db60aac4edf29da8cf09b6bd9 krunner-5.37.0.tar.xz
#f4e54c14d94e70c154ebc4d57d868b2f prison-5.37.0.tar.xz
#74de56d367913ec08c547e916bfe3b24 kirigami2-5.37.0.tar.xz
4ef52deab5f709ddf0d3e99bf7747077 kjs-5.37.0.tar.xz
7584d933213c7a3f56c55f1eede7b717 kdelibs4support-5.37.0.tar.xz
691bc2e2a5b763e21333fbac28d039b3 khtml-5.37.0.tar.xz
d21ea2f8177d503b826809b614e37471 kjsembed-5.37.0.tar.xz
73d2101fb4aa04df9918b46e1e91bf7a kmediaplayer-5.37.0.tar.xz
cd2f2748eed19cfe8552b6444c27a021 kross-5.37.0.tar.xz
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
        syntax-highlighting* )
          sed -i.orig 's|w-|w\\-|' data/syntax/rest.xml
        ;;
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
done < frameworks-5.37.0.md5
exit



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /opt/kf5 /opt/kf5-5.37.0
ln -sfvn kf5-5.37.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
