#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:apache-tomcat:8.0.36

cd $SOURCE_DIR

URL=http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /opt/
sudo ln -s /opt/$DIRECTORY /opt/tomcat
sudo tee /etc/profile.d/tomcat.sh<<"EOF"
export CATALINA_HOME=/opt/tomcat
pathappend $M2_HOME/bin
EOF

cd $SOURCE_DIR

echo "tomcat8=>`date`" | sudo tee -a $INSTALLED_LIST


