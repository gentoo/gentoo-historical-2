# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org> 
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-2.2.4-r8.ebuild,v 1.3 2001/12/27 02:55:03 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU libc6 (also called glibc2) C library"
SRC_URI="ftp://sources.redhat.com/pub/glibc/releases/glibc-${PV}.tar.bz2
	 ftp://sources.redhat.com/pub/glibc/releases/glibc-linuxthreads-${PV}.tar.bz2
	 http://www.ibiblio.org/gentoo/distfiles/glibc-manpages-${PV}.tar.bz2"
HOMEPAGE="http://www.gnu.org/software/libc/libc.html"

#Specific Linux headers are now required so that we build from a stable "base"
#portage-1.8 needed for smart library merging feature (avoids segfaults on glibc upgrade)
LHV=2.4.16
DEPEND=">=sys-apps/portage-1.8 ~sys-kernel/linux-headers-${LHV} nls? ( sys-devel/gettext ) gd? ( media-libs/libgd )"
RDEPEND="~sys-kernel/linux-headers-${LHV}"

if [ -z "`use build`" ]
then
	RDEPEND="$RDEPEND gd? ( sys-libs/zlib media-libs/libpng ) sys-apps/baselayout"
else
	RDEPEND="$RDEPEND sys-apps/baselayout"
fi

PROVIDE="virtual/glibc"

src_unpack() {
	unpack glibc-${PV}.tar.bz2
	cd ${S}
	#extract pre-made man pages.  Otherwise we need perl, which is a no-no.
	mkdir man; cd man
	tar xjf ${DISTDIR}/glibc-manpages-${PV}.tar.bz2
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
	sed -e 's/"=m" (lock->__status) : "0" (lock->__status/"+m" (lock->__status/g' spinlock.c.orig > spinlock.c
	#This patch addresses a nasty buffer overflow in glob(), remotely exploitable too. See:
	#http://lwn.net/2001/1220/a/glibc-vulnerability.php3
	cd ${S}
	patch -p1 < ${FILESDIR}/glibc-2.2.4-glob-overflow.diff || die
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
		make PARALLELMFLAGS="${MAKEOPTS}" install_root=${D} info -C buildhere || die
		make PARALLELMFLAGS="${MAKEOPTS}" install_root=${D} localedata/install-locales -C buildhere || die
		#install linuxthreads man pages
		dodir /usr/share/man/man3
		doman ${S}/man/*.3thr	
		install -m 644 nscd/nscd.conf ${D}/etc
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

	#prevent overwriting of the /etc/localtime symlink.  We'll handle the
	#creation of the "factory" symlink in pkg_postinst().
	rm -f ${D}/etc/localtime
}

pkg_postinst()
{
	if [ ! -e ${ROOT}etc/localtime ]
	then
		echo "Please remember to set your timezone using the zic command."
		ln -s ../usr/share/zoneinfo/Factory ${ROOT}/etc/localtime	
	fi	
}
