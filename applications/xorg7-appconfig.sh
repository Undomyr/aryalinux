#!/bin/bash
set -e
set +h

function postinstall()
{

export XORG_PREFIX=/usr

cat >> /etc/profile.d/xorg.sh << "EOF"
pathappend $XORG_PREFIX/bin             PATH
pathappend $XORG_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend $XORG_PREFIX/share/pkgconfig PKG_CONFIG_PATH
pathappend $XORG_PREFIX/lib             LIBRARY_PATH
pathappend $XORG_PREFIX/include         C_INCLUDE_PATH
pathappend $XORG_PREFIX/include         CPLUS_INCLUDE_PATH
ACLOCAL='aclocal -I $XORG_PREFIX/share/aclocal'
export PATH PKG_CONFIG_PATH ACLOCAL LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
EOF

echo "$XORG_PREFIX/lib" >> /etc/ld.so.conf

}


preinstall()
{
echo "#"
}


$1
