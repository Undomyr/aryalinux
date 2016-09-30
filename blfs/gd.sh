#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -c $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

cat > gd-1-fix-libvpx.patch <<EOF
This file is part of MXE.
See index.html for further information.

This patch has been taken from:
https://github.com/libgd/libgd/commit/d41eb72cd4545c394578332e5c102dee69e02ee8

--- a/src/webpimg.c	2013-06-25 10:58:23.000000000 +0100
+++ b/src/webpimg.c	2015-06-20 21:35:50.345100568 +0100
@@ -711,14 +711,14 @@
     codec_ctl(&enc, VP8E_SET_STATIC_THRESHOLD, 0);
     codec_ctl(&enc, VP8E_SET_TOKEN_PARTITIONS, 2);
 
-    vpx_img_wrap(&img, IMG_FMT_I420,
+    vpx_img_wrap(&img, VPX_IMG_FMT_I420,
                  y_width, y_height, 16, (uint8*)(Y));
-    img.planes[PLANE_Y] = (uint8*)(Y);
-    img.planes[PLANE_U] = (uint8*)(U);
-    img.planes[PLANE_V] = (uint8*)(V);
-    img.stride[PLANE_Y] = y_stride;
-    img.stride[PLANE_U] = uv_stride;
-    img.stride[PLANE_V] = uv_stride;
+    img.planes[VPX_PLANE_Y] = (uint8*)(Y);
+    img.planes[VPX_PLANE_U] = (uint8*)(U);
+    img.planes[VPX_PLANE_V] = (uint8*)(V);
+    img.stride[VPX_PLANE_Y] = y_stride;
+    img.stride[VPX_PLANE_U] = uv_stride;
+    img.stride[VPX_PLANE_V] = uv_stride;
 
     res = vpx_codec_encode(&enc, &img, 0, 1, 0, VPX_DL_BEST_QUALITY);
 

EOF

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../gd-1-fix-libvpx.patch
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "gd=>`date`" | sudo tee -a $INSTALLED_LIST
