# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/baselayout/baselayout-1.5-r4.ebuild,v 1.3 2001/10/06 17:04:49 drobbins Exp $# Copyright 1999-2000 Gentoo Technologies, Inc.

S=${WORKDIR}/${P}
DESCRIPTION="Base layout for Gentoo Linux filesystem (incl. initscripts)"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org"

if [ -z "`use bootcd`" ]
then
	INIT_D_SCRIPTS="bootmisc checkfs checkroot clock halt hostname
                    inet initscripts-install isapnp keymaps local
                    modules mountall mountall.test pretty rc reboot
                    rmnologin sendsigs serial single umountfs urandom
                    vcron"
else
	INIT_D_SCRIPTS="cdboot cdscan"
fi


src_install()
{
	if [ "$MAINTAINER" != "yes" ] && [ "$ROOT" = "/" ]
	then
	echo '!!! baselayout should only be merged if you know what youre doing.'
	echo '!!! It will overwrite important system files (passwd/group and others) with their'
	echo '!!! original versions.  For now, please update your files by hand by'
	echo '!!! comparing the contents of the files in '${FILESDIR}' to your'
	echo '!!! installed versions.  We will have an automated update system shortly.'
	exit 1
	fi
	dodir /usr
	if [ -z "`bootcd`" ]
	then
		dodir /boot /home
		dodir /usr/include /usr/src /usr/portage /usr/X11R6/include/GL
		dosym ../X11R6/include/X11 /usr/include/X11
		dosym ../X11R6/include/GL /usr/include/GL
		dosym ../src/linux/include/linux /usr/include/linux
		dosym ../src/linux/include/asm-i386 /usr/include/asm
		local foo
		for foo in games man lib sbin share bin doc src
		do
		  dodir /usr/local/${foo}
		done
	fi
	
	dodir /usr/bin
	dodir /usr/lib
	dodir /usr/sbin
	dosbin ${FILESDIR}/MAKEDEV ${FILESDIR}/run-crons
	
	if [ -z "`use bootcd`" ]
	then
		dodir /usr/share/man /usr/share/info /usr/share/doc /usr/share/misc
		
#FHS 2.1 stuff
		dosym share/man /usr/man
		dosym share/doc /usr/doc
		dosym share/info /usr/info
#end FHS 2.1 stuff
	fi
	
	dosym ../var/tmp /usr/tmp
	
	if [ -z "`use bootcd`" ]
	then
		doman ${FILESDIR}/MAKEDEV.8
		dodoc ${FILESDIR}/copyright ${FILESDIR}/changelog.Debian
		dodir /usr/X11R6/lib /usr/X11R6/share/man
		ln -s share/man ${D}/usr/X11R6/man
	fi
	dodir /var /var/run /var/lock/subsys
	if [ -z "`use bootcd`" ]
	then
		dodir /var/log/news
	fi
	touch ${D}/var/log/lastlog
	touch ${D}/var/run/utmp
	touch ${D}/var/log/wtmp
	dodir /var/db/pkg /var/spool /var/tmp /var/lib/misc
	chmod 1777 ${D}/var/tmp
	
	if [ -z "`use bootcd`" ]
	then
#supervise stuff
		dodir /var/lib/supervise
		install -d -m0750 -o root -g wheel ${D}/var/lib/supervise/control
		install -d -m0750 -o root -g wheel ${D}/var/lib/supervise/services
#end supervise stuff
		
		dodir /opt
	fi
	
	dodir /root /etc/modules /proc
	
	chmod go-rx ${D}/root
	dodir /tmp
	chmod 1777 ${D}/tmp
	chmod 1777 ${D}/var/tmp
	chown root.uucp ${D}/var/lock
	chmod 775 ${D}/var/lock
	insopts -m0644
	insinto /etc
	ln -s ../proc/filesystems ${D}/etc/filesystems
	#makes things always up-to-date ^
	for foo in services passwd shadow nsswitch.conf \
	           inetd.conf ld.so.conf protocols fstab \
		   hosts syslog.conf pwdb.conf \
		   group profile crontab inputrc networks
	do
		doins ${FILESDIR}/${foo}
	done
	if [ -z "`use bootcd`" ]
	then
		for foo in hourly daily weekly monthly
		  do
		  dodir /etc/cron.$foo
		done
	fi
	chmod go-rwx ${D}/etc/shadow
	dodir /lib /proc /mnt/floppy /mnt/cdrom
	chmod go-rwx ${D}/mnt/floppy ${D}/mnt/cdrom

	for x in boot halt 1 2 3 4 5 
	do
	  dodir /etc/rc.d/rc${x}.d
	done
	dosym rcboot.d /etc/rc.d/rc0.d
	dosym rchalt.d /etc/rc.d/rc6.d
	
	if [ -z "`use bootcd`" ]
	then
		dodir /etc/pam.d
		cd ${FILESDIR}/pam.d
		insinto /etc/pam.d
		doins *
	fi
	
	dodir /etc/rc.d/init.d
	dodir /etc/rc.d/config
	cd ${FILESDIR}/rc.d/init.d
	exeinto /etc/rc.d/init.d
	doexe ${INIT_D_SCRIPTS}
	
	insinto /etc/rc.d/init.d/extra_scripts
	cd ${FILESDIR}/rc.d/config
	insinto /etc/rc.d/config
	doins *
	doins runlevels
	cd ${FILESDIR}
	insinto /etc
	doins inittab
	into /usr
	dosbin rc-update 
	insinto /usr/bin
	insopts -m0755
	doins colors
  	dodir /dev
	dodir /dev-state
	#dodir /dev/pts /dev/shm
	#dosym /usr/sbin/MAKEDEV /dev/MAKEDEV
	cd ${D}/dev
	MAKEDEV generic-i386
	#These devices are also needed by many people and should be included
	MAKEDEV sg
	MAKEDEV scd
	MAKEDEV rtc 
	MAKEDEV audio
	MAKEDEV hde
	MAKEDEV hdf
	MAKEDEV hdg
	MAKEDEV hdh
	cd ${D}/etc/rc.d/config
	cp runlevels runlevels.orig
	sed -e 's:##OSNAME##:Gentoo Linux:g' -e "s:##ARCH##:${CHOST%%-*}:g" runlevels.orig > runlevels
	rm runlevels.orig
	
#env-update stuff
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/00basic
#end env-update stuff
	
}
