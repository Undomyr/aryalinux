N.B. Build scripts are present in the branches corresponding to the version of aryalinux you are trying to build. Please checkout the appropriate branch to view the build scripts.

ABOUT PROJECT

This project stores all the scripts that are used to build AryaLinux from scratch

There are three parts to building Aryalinux:
1) Base System
2) X Server and Desktop Environment
3) Applications

BASE SYSTEM

The base System is roughly the same as the system one would end up building by following
the LFS book. Apart from the packages listed in LFS, in the base system that Aryalinux
consists of are the following packages and their dependencies:

 * wget
 * sudo
 * os-prober
 * busybox
 * dracut

Each of these packages has a definite purpose and reason for being included in the base-system
just as each package that gets built and installed before it. Wget is used to download the source
tarballs for the various packages that would help build the system. Sudo helps in user rights
management. Since packages are built as regular user and installed as the root user, sudo makes
executing the install commands easier. os-prober helps in detecting the various operating systems
that are installed in the hard disk other than AryaLinux so that they can be listed during boot.
Busybox is used in the initrd. Dracut immensely simplifies the process of creating initrd.

The base system can be built by running the following command:

./1.sh

The scripts that run and follow are interactive and expect user input at regular intervals.
Once all the scripts complete execution, the base system would be built and installed and
one could boot into it.

X-SERVER AND DESKTOP ENVIRONMENT

Once the base system is built one can use the alps tool(that gets installed with the base system)
to build the rest of the system i.e. X-Server and XFCE/Mate. Other desktop environments are not
currently supported but soon we would support Gnome, KDE and LXDE as well.

APPLICATIONS

After Desktop Environment is built, applications can be built depending on the preferences of
the user. Applications that can be installed in this stage are:

 * Internet Applications (firefox, thunderbird, pidgin, hexchat, transmission)
 * Multimedia Players (VLC, mplayer, audacious)
 * Libreoffice
 * Other applications (gimp, xfburn etc..)

HOW TO USE THE SCRIPTS

Download the scripts into the /root directory inside a directory named scripts. So all scripts
in the scripts directory should be present in /root/scripts. Then execute the following commands:

cd scripts
./download-sources.sh
./additional-downloads.sh
./1.sh

As soon as 1.sh is executed you would be asked for several inputs in an interactive manner. Just
enter the details asked for and wait for the scripts to finish one by one. When one script would
end, it would print instructions to run the next script. Just follow the instructions as given.
Once 4.sh finishes, your system would be ready. You can reboot to log into the new system.

Once this is done, to build the rest of the system you can follow our online documentation that
is available in aryalinux.org/documentation/

To Enter the chroot environment, you need to do the following:

* Boot into the system that you used to build Aryalinux. In case your grub menu does not show that
option any more, just boot into AryaLinux and run this command:

grub-mkconfig -o /boot/grub/grub.cfg

* Open a terminal and log in as root:

sudo su

* Then run the follwing commands:

cd /root
cd scripts
./enteral.sh

Enter the partition details asked for. Then run:

su - <username>

Packages can now be installed using the following command:

alps install <package-name>
