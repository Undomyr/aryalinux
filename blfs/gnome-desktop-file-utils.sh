#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

cd $SOURCE_DIR

echo "gnome-desktop-file-utils=>`date`" | sudo tee -a $INSTALLED_LIST
