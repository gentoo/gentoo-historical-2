# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: System Team <system@gentoo.org>
# Author: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/baselayout/baselayout-1.6.2.ebuild,v 1.1 2001/09/03 04:57:28 drobbins Exp $

SV=1.1.5
S=${WORKDIR}/rc-scripts-${SV}
DESCRIPTION="Base layout for Gentoo Linux filesystem (incl. initscripts)"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/rc-scripts-${SV}.tar.bz2"
HOMEPAGE="http://www.gentoo.org"

src_compile() {
	cp ${S}/init.d/runscript.c ${T}
	cd ${T}
	gcc ${CFLAGS} runscript.c -o runscript
}

#adds ".keep" files so that dirs aren't auto-cleaned
keepdir() {
	dodir $*
	local x
	for x in $*
	do
		touch ${D}/${x}/.keep
	done
}

src_install()
{
	local foo
	if [ "$MAINTAINER" != "yes" ] && [ "$ROOT" = "/" ]
	then
		echo '!!! baselayout should only be merged if you know what youre doing.'
		echo '!!! It will overwrite important system files (passwd/group and others) with their'
		echo '!!! original versions.  For now, please update your files by hand by'
		echo '!!! comparing the contents of the files in '${FILESDIR}' to your'
		echo '!!! installed versions.  We will have an automated update system shortly.'
		exit 1
	fi
	keepdir /sbin
	exeinto /sbin
	doexe ${T}/runscript

	keepdir /usr
	keepdir /usr/bin
	keepdir /usr/lib
	keepdir /usr/sbin
	dosbin ${S}/sbin/MAKEDEV ${S}/sbin/run-crons ${S}/sbin/update-modules
	keepdir /var /var/run /var/lock/subsys
	dosym ../var/tmp /usr/tmp
	
	if [ -z "`use bootcd`" ]
	then
		keepdir /boot
		dosym . /boot/boot
		keepdir /home
		keepdir /usr/include /usr/src /usr/portage /usr/X11R6/include/GL
		dosym ../X11R6/include/X11 /usr/include/X11
		dosym ../X11R6/include/GL /usr/include/GL
		
		#dosym ../src/linux/include/linux /usr/include/linux
		#dosym ../src/linux/include/asm-i386 /usr/include/asm
		#Important note: Gentoo Linux 1.0_rc6 no longer uses symlinks to /usr/src for includes.
		#We now rely on the special sys-kernel/linux-headers package, which takes a snapshot of
		#the currently-installed includes in /usr/src and copies them to /usr/include/linux and
		#/usr/include/asm.  This is the recommended approach so that kernel includes can remain
		#constant.  The kernel includes should really only be upgraded when you upgrade glibc.
		keepdir /usr/include/linux /usr/include/asm
		keepdir /usr/share/man /usr/share/info /usr/share/doc /usr/share/misc

		for foo in games lib sbin share bin share/doc share/man src
		do
		  keepdir /usr/local/${foo}
		done
		#local FHS compat symlinks
		dosym share/man /usr/local/man	
		dosym share/doc	/usr/local/doc	

		#FHS compatibility symlinks stuff
		dosym share/man /usr/man
		dosym share/doc /usr/doc
		dosym share/info /usr/info
		keepdir /usr/X11R6/share
		dosym ../../share/info	/usr/X11R6/share/info
		#end FHS compatibility symlinks stuff
		
		doman ${FILESDIR}/MAKEDEV.8
		dodoc ${FILESDIR}/copyright ${FILESDIR}/changelog.Debian
		keepdir /usr/X11R6/lib /usr/X11R6/man
		keepdir /var/log/news
		
		#supervise stuff depreciated
		#dodir /var/lib/supervise
		#install -d -m0750 -o root -g wheel ${D}/var/lib/supervise/control
		#install -d -m0750 -o root -g wheel ${D}/var/lib/supervise/services
		#end supervise stuff
		
		keepdir /opt
		keepdir /opt/gnome/man
		keepdir /opt/gnome/share
		dosym ../man /opt/gnome/share/man
	fi
	
	touch ${D}/var/log/lastlog
	touch ${D}/var/run/utmp
	touch ${D}/var/log/wtmp
	#the .keep file messes up Portage when looking in /var/db/pkg
	dodir /var/db/pkg 
	keepdir /var/spool /var/tmp /var/lib/misc
	chmod 1777 ${D}/var/tmp
	keepdir /root
	
	#/proc is very likely mounted right now so a keepdir will fail on merge
	dodir /proc	
	
	chmod go-rx ${D}/root
	keepdir /tmp
	chmod 1777 ${D}/tmp
	chmod 1777 ${D}/var/tmp
	chown root.uucp ${D}/var/lock
	chmod 775 ${D}/var/lock
	insopts -m0644
	
	insinto /etc
	ln -s ../proc/filesystems ${D}/etc/filesystems
	for foo in hourly daily weekly monthly
	do
		keepdir /etc/cron.${foo}
	done
	for foo in ${S}/etc/*
	do
		#install files, not dirs
		[ -f $foo ] && doins $foo
	done
	#going back to symlink mtab; it just plain works better
	ln -s /proc/mounts /etc/mtab
	chmod go-rwx ${D}/etc/shadow
	keepdir /lib /mnt/floppy /mnt/cdrom
	chmod go-rwx ${D}/mnt/floppy ${D}/mnt/cdrom

#	dosbin rc-update 
#	insinto /usr/bin
#	insopts -m0755
#	doins colors
  	keepdir /dev
	keepdir /dev-state
	keepdir /dev/pts /dev/shm
	dosym /usr/sbin/MAKEDEV /dev/MAKEDEV
	cd ${D}/dev
	#These devices are also needed by many people and should be included
	echo "Making device nodes... (this could take a minute or so...)"
	${S}/sbin/MAKEDEV generic-i386
	${S}/sbin/MAKEDEV sg
	${S}/sbin/MAKEDEV scd
	${S}/sbin/MAKEDEV rtc 
	${S}/sbin/MAKEDEV audio
	${S}/sbin/MAKEDEV hde
	${S}/sbin/MAKEDEV hdf
	${S}/sbin/MAKEDEV hdg
	${S}/sbin/MAKEDEV hdh

	cd ${S}/sbin
	into /
	dosbin init rc rc-update

	#env-update stuff
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${S}/etc/env.d/00basic
	
	dodir /etc/modules.d
	insinto /etc/modules.d
	doins ${S}/etc/modules.d/aliases ${S}/etc/modules.d/i386

	dodir /etc/init.d
	exeinto /etc/init.d
	for foo in ${S}/init.d/*
	do
		[ -f $foo ] && doexe $foo
	done
	#not the greatest location for this file; should move it on cvs at some point
	rm ${S}/etc/init.d/runscript.c

	#set up default runlevel symlinks
	local bar
	for foo in default boot nonetwork single
	do
		dodir /etc/runlevels/${foo}
		for bar in `cat ${S}/rc-lists/${foo}`
		do
			[ -e ${S}/init.d/${bar} ] && dosym /etc/init.d/${bar} /etc/runlevels/${foo}/${bar}
		done
	done
}
