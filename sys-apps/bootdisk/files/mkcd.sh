#!/bin/sh

if [ -z "$ROOT" ]
then
   echo "ROOT not set !"
   exit 1
fi

dodirs() {
  for i in $@
  do
    mkdir $i
  done
}

doexes() {
  for i in $@
  do
    cp `which $i` $i
    strip $i
  done
}


cd ${ROOT}

echo "Creating basic dirs"

dodirs bin dev initrd lib mnt proc sbin usr 



echo "Populating /initrd"
cd ${ROOT}/initrd

dodirs dev etc root tmp var

touch portage

mkdir pts
mknod dev/tty1 c 4 1 
mknod dev/tty2 c 4 2


echo "Creating links to initrd"
cd ${ROOT}

for i in etc root tmp var
do
  ln -s initrd/$i $i
done

echo "Creating devices"
cd ${ROOT}/dev
ln -s ../initrd/pts pts
ln -sf ../initrd/dev/initctl .
ln -sf ../initrd/dev/tty1 .
ln -sf ../initrd/dev/tty2 .

for i in console fd0 fd0u1440 hd[abcd]* kmem loop[012] \
         mem null ptmx ram[01234] scd* sd[abcd]* ttyp[01] ttys[01] \
	 urandom zero
do
    cp -af /dev/$i .
done

ln -s ram0 ram
mknod initrd b 1 250

echo "Creating /mnt dirs"
cd ${ROOT}/mnt

dodirs floppy gentoo ram

ln -s ../initrd/portage .

cd ${ROOT}/bin

echo "Populating /bin"
doexes bash cat chgrp chmod chown cp df du hostname kill ln login \
	 ls mkdir mknod mount mv ping ps rm umount uname

ln -s bash sh

echo "Populating /sbin"

cd ${ROOT}/sbin

doexes agetty depmod e2fsck fdisk halt ifconfig init insmod \
	 ldconfig lilo ln lsmod mke2fs mkraid mkreiserfs mkswap \
	 portmap raidstart reboot reiserfsck resize2fs resize_reiserfs \
	 route sfdisk shutdown touch


ln -s insmod modprobe
ln -s mkraid raid0run
ln -s raidstart raidhotadd 
ln -s raidstart raidhotremove
ln -s raidstart raidstop

cp /usr/portage/gentoo-x86/autoinstaller.sh .

echo "Creating /usr dirs"
cd ${ROOT}/usr

dodirs bin lib sbin share
echo "Populating /usr/bin"
cd ${ROOT}/usr/bin

doexes awk bzip2 cut expr fdformat ftp grep gzip joe killall ldd \
	loadkeys most rm rmdir scp sed ssh tar top vi 

echo "Populating /usr/sbin"
cd ${ROOT}/usr/sbin

doexes rc-update

echo "Populating /usr/share"
cd ${ROOT}/usr/share

echo "keymaps"
cp -af /usr/share/keymaps .
echo "tabset"
cp -af /usr/share/tabset .
echo "terminfo"
cp -af /usr/share/terminfo .

echo "Populating /lib/modules"
cd ${ROOT}/lib
cp -af /lib/modules .

echo "Populating /usr/lib/security"
cd ${ROOT}/usr/lib

mkdir security

cp /usr/lib/security/pam_permit.so .

for j in "/bin" "/sbin" "/usr/bin" "/usr/sbin"
do

    echo "Finding required libs for $j"

  myfiles=`find ${ROOT}$j -print | /usr/lib/portage/bin/find-requires | grep -v "/bin/bash" | grep -v "/bin/sh"`

  for i in $myfiles
  do
      if [ -f /lib/$i ]
      then
          cp /lib/$i ${ROOT}/lib/$i
	  strip ${ROOT}/lib/$i
      else
          if [ -f /usr/lib/$i ]
          then
              cp /usr/lib/$i ${ROOT}/usr/lib/$i
	      strip ${ROOT}/usr/lib/$i
          else
              echo "$i not found !"
          fi
      fi
  done

done
