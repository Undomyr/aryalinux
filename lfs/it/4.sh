#!/bin/bash

set -e
set +h

SOURCE_DIR="/sources"

. ./build-properties

if ! grep "config-files" /sources/build-log &> /dev/null
then

cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf

domain $DOMAIN_NAME

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

echo "$HOST_NAME" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
::1       localhost

# End /etc/hosts (network card version)
EOF

cat > /etc/udev/rules.d/83-duplicate_devs.rules << "EOF"

# Persistent symlinks for webcam and tuner
KERNEL=="video*", ATTRS{idProduct}=="1910", ATTRS{idVendor}=="0d81", \
    SYMLINK+="webcam"
KERNEL=="video*", ATTRS{device}=="0x036f", ATTRS{vendor}=="0x109e", \
    SYMLINK+="tvtuner"

EOF

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

cat > /etc/locale.conf << EOF
LANG=$LOCALE
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line


# End /etc/inputrc
EOF

cat > /etc/vconsole.conf << EOF
KEYMAP=$KEYBOARD
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

UUID=$ROOT_PART_BY_UUID     /            ext4     defaults            1     1
EOF

if [ "x$SWAP_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$SWAP_PART_BY_UUID     swap         swap     pri=1               0     0
EOF
fi

if [ "x$HOME_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$HOME_PART_BY_UUID     /home        ext4     defaults            1     1
EOF
fi

cat >> /etc/fstab <<EOF

# End /etc/fstab
EOF

fi

if ! grep initramfs /sources/build-log &> /dev/null
then
	./initramfs.sh
fi

if ! grep "014-openssl.sh" /sources/build-log &> /dev/null
then
	extras/014-openssl.sh
fi

./lvm2.sh

if ! grep kernel /sources/build-log &> /dev/null
then
	./kernel.sh
fi

for script in extras/*.sh
do
	$script
done

cd $SOURCE_DIR
tar xf syslinux-4.06.tar.xz
cd syslinux-4.06
cd utils
make
cp isohybrid /usr/bin/
cd $SOURCE_DIR
rm -r syslinux-4.06

if ! grep "user-and-passwords" /sources/build-log &> /dev/null
then

clear
echo "Sto settango la password per root  :"
passwd root

clear
echo "Sto creando un utente con nome  $FULLNAME e username : $USERNAME"
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
echo "Sto settando la password $USERNAME :"
passwd $USERNAME
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
groupadd wheel
usermod -a -G wheel $USERNAME

echo "Tutto pronto. Adesso puoi uscire scrivendo il seguente comando :"
echo ""
echo "exit"
echo ""

fi
