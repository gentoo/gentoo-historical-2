# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-2.2.4-r4.ebuild,v 1.3 2001/12/08 15:59:02 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU libc6 (also called glibc2) C library"
SRC_URI="ftp://sources.redhat.com/pub/glibc/releases/glibc-${PV}.tar.bz2
	 ftp://sources.redhat.com/pub/glibc/releases/glibc-linuxthreads-${PV}.tar.bz2
	 ftp://ftp.unina.it/pub/Unix/cygnus/glibc/releases/glibc-linuxthreads-${PV}.tar.bz2
	 ftp://ftp.gnu.org/pub/gnu/glibc/glibc-linuxthreads-${PV}.tar.bz2"
HOMEPAGE="http://www.gnu.org/software/libc/libc.html"

#Specific Linux headers are now required so that we build from a stable "base"
#We need gcc-2.95.3-r2 because it includes a special fix for this glibc version (2.2.4)
DEPEND="~sys-kernel/linux-headers-2.4.16 nls? ( sys-devel/gettext ) gd? ( media-libs/libgd )"

if [ -z "`use bootstrap`" ] && [ -z "`use bootcd`" ] && [ -z "`use build`" ]
then
	RDEPEND="gd? ( sys-libs/zlib media-libs/libpng ) sys-apps/baselayout"
else
	RDEPEND="sys-apps/baselayout"
fi

PROVIDE="virtual/glibc"

src_unpack() {
	unpack glibc-${PV}.tar.bz2
	cd ${S}
	unpack glibc-linuxthreads-${PV}.tar.bz2
	for i in mtrace-intl-perl
	do
		echo "Applying $i patch..."
		patch -p0 < ${FILESDIR}/glibc-2.2.2-${i}.diff || die
	done
	#For information about the string2 patch, see: http://lists.gentoo.org/pipermail/gentoo-dev/2001-June/001559.html
	patch -p0 < ${FILESDIR}/glibc-2.2.3-string2.diff || die
	cd io
	#To my knowledge, this next patch fixes a test that will timeout due to ReiserFS' slow handling of sparse files
	patch -p0 < ${FILESDIR}/glibc-2.2.2-test-lfs-timeout.patch || die
	#now we need to fix a problem where glibc doesn't compile with absolutely no -O optimizations.
	#we'll need to keep our eyes on this one to see how things are in later versions of linuxthreads:
	#for more info, see:
	# http://gcc.gnu.org/ml/gcc-prs/2001-06/msg00044.html
	# http://www.mail-archive.com/bug-glibc@gnu.org/msg01820.html
	cd ${S}/linuxthreads
	cp spinlock.c spinlock.c.orig
	sed -e 's/ : "0" (lock->__status)//g' spinlock.c.orig > spinlock.c
}

src_compile() {
	local myconf
	# If we build for the build system we use the kernel headers from the target
	[ "`use build`" ] && myconf="--with-header=${ROOT}usr/include"
	if [ "`use gd`" ] && [ -z "`use bootstrap`" ] && [ -z "`use build`" ]
	then
		myconf="${myconf} --with-gd=yes"
	else
		myconf="${myconf} --with-gd=no"
	fi
	[ -z "`use nls`" ] && myconf="${myconf} --disable-nls"
	rm -rf buildhere
	mkdir buildhere
	cd buildhere
	../configure --host=${CHOST} --without-cvs --enable-add-ons=linuxthreads --disable-profile --prefix=/usr \
		--mandir=/usr/share/man --infodir=/usr/share/info --libexecdir=/usr/lib/misc ${myconf} || die
	
	#This next option breaks the Sun JDK and the IBM JDK
	#We should really keep compatibility with older kernels, anyway
	#--enable-kernel=2.4.0
	make PARALLELMFLAGS="${MAKEOPTS}" || die
	make check
}


src_install() {
	export LC_ALL=C
	make PARALLELMFLAGS="${MAKEOPTS}" install_root=${D} install -C buildhere || die
	if [ -z "`use build`" ]
	then
		dodir /etc/rc.d/init.d
		make PARALLELMFLAGS="${MAKEOPTS}" install_root=${D} info -C buildhere || die
		make PARALLELMFLAGS="${MAKEOPTS}" install_root=${D} localedata/install-locales -C buildhere || die

		# I commented out linuxthreads man pages because I don't want glibc to build depend on perl, but we really
		# should fix this.
		# dodir /usr/share/man/man3
		# make MANDIR=${D}/usr/share/man/man3 install -C linuxthreads/man || die
		# cd ${D}/usr/share/man/man3
		# for i in *.3thr
		# do
		# mv ${i} ${i%.3thr}.3
		# done
		
		install -m 644 nscd/nscd.conf ${D}/etc
		install -m 755 ${FILESDIR}/nscd ${D}/etc/rc.d/init.d/nscd
		dodoc BUGS ChangeLog* CONFORMANCE COPYING* FAQ INTERFACE NEWS NOTES PROJECTS README*
	else
		rm -rf ${D}/usr/share ${D}/usr/lib/gconv
	fi
	if [ "`use pic`" ] 
	then
		find ${S}/buildhere -name "*_pic.a" -exec cp {} ${D}/lib \;
		find ${S}/buildhere -name "*.map" -exec cp {} ${D}/lib \;
		for i in ${D}/lib/*.map
		do
			mv ${i} ${i%.map}_pic.map
		done
	fi
	rm ${D}/lib/ld-linux.so.2
	rm ${D}/lib/libc.so.6
	rm ${D}/lib/libpthread.so.0
	#is this next line actually needed or does the makefile get it right.  It previously has 0755 perms which was
	#killing things.
	chmod 4755 ${D}/usr/lib/misc/pt_chown
	rm -f ${D}/etc/ld.so.cache
}

pkg_preinst()
{
	local mytarget	
	echo "Backing up existing critical libraries..."
	[ ! -d ${ROOT}lib/old ] && mkdir ${ROOT}lib/old
	for file in ld-linux.so.2 libc.so.6 libpthread.so.0
	do
		if [ -f ${ROOT}lib/${file} ]
		then
			#all this "mytarget" stuff allows us to create a backup
			#library in /lib/old with the *real* version name
			#rather than the *generic* version name.
	
			mytarget="`readlink ${ROOT}lib/${file}`"
			mytarget="`basename $mytarget`"
			/bin/cp ${ROOT}lib/${file} ${ROOT}lib/old/${mytarget}
			/sbin/sln ${ROOT}lib/old/${mytarget} ${ROOT}lib/${file}
		fi
	done
    
	[ ! -e ${ROOT}etc/localtime ] && echo "Please remember to set your timezone using the zic command."
	return 0
}

pkg_postinst()
{
	/sbin/sln ld-${PV}.so ${ROOT}lib/ld-linux.so.2
	/sbin/sln libc-${PV}.so ${ROOT}lib/libc.so.6
	/sbin/sln libpthread-0.9.so ${ROOT}lib/libpthread.so.0
	#we used to delete the backup libraries; we don't do this anymore.
	#other apps may still have them mapped into their address space,
	#but this shouldn't be a problem.  The main reason is if something
	#goes wrong with the new lib install.	It's just a nicer way of
	#handling things, imho.
	/sbin/ldconfig -r ${ROOT}
	return 0
}
