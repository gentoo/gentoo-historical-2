# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/ncurses/ncurses-5.2.20020511-r3.ebuild,v 1.4 2003/01/06 21:20:34 tuxus Exp $

inherit eutils flag-o-matic

filter-flags "-fno-exceptions"

MY_PV=${PV%.*}

S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="Linux console display libarary"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${PN}-${MY_PV}.tar.gz
	http://www.ibiblio.org/gentoo/distfiles/${PN}-${PV}.diff.bz2"
	#ftp://dickey.his.com/${PN}/${PV}/patch-${MY_PV}-20020427.sh.gz
	#ftp://dickey.his.com/${PN}/${PV}/${PN}-${MY_PV}-20020429.patch.gz
	#ftp://dickey.his.com/${PN}/${PV}/${PN}-${MY_PV}-20020511.patch.gz"
HOMEPAGE="http://www.gnu.org/software/ncurses/ncurses.html"
# bzip2 is needed to apply the patch. added 20020609 danarmak.

LICENSE="MIT"
SLOT="5"
KEYWORDS="x86 ppc sparc alpha mips"

DEPEND="virtual/glibc
	sys-apps/bzip2"

RDEPEND="virtual/glibc"


src_unpack() {

	unpack ${PN}-${MY_PV}.tar.gz
	
	#this is how the gentoo patch was created.  avoids a dependency
	#on sharutils for uudecode :/
	#( zcat ${DISTDIR}/patch-${MY_PV}-20020427.sh.gz | sh ) || die
	#( zcat ${DISTDIR}/${PN}-${MY_PV}-20020429.patch.gz | patch -p1 ) || die
	#( zcat ${DISTDIR}/${PN}-${MY_PV}-20020511.patch.gz | patch -p1 ) || die
	#this is the generated patch..
	# bzcat doesn't always exist (i.e. making stage1), bunzip2 is safer
	# Gerk - June 26 2002
	( cd ${S}; bunzip2 -c ${DISTDIR}/${PN}-${PV}.diff.bz2 | patch -p1 ) || die

	cd ${S}
	# Do not compile tests
	rm -rf test/*
	echo "all:" > test/Makefile.in
	echo "install:" >> test/Makefile.in
}

src_compile() {

	[ -z "$DEBUGBUILD" ] && myconf="${myconf} --without-debug"

	econf --libdir=/lib \
		--enable-symlinks \
		--disable-termcap \
		--with-shared \
		--with-rcs-ids \
		${myconf} || die

	# this patch is completely invalid.  whoever was responsible for
	# generating it for the previous snapshots, please investigate with
	# regards to this current snapshot.
	#	patch -p1 <${FILESDIR}/ncurses-5.2.20020511-gcc31.patch

	#emake still doesn't work circa 25 Mar 2002
	make || die
}

src_install() {

	dodir /usr/lib
	make DESTDIR=${D} install || die

	cd ${D}/lib
	dosym libncurses.a /lib/libcurses.a
	chmod 755 ${D}/lib/*.${MY_PV}
	mv libform* libmenu* libpanel* ../usr/lib
	mv *.a ../usr/lib
	# bug #4411
	gen_usr_ldscript libncurses.so

	#with this fix, the default xterm has color as it should
	cd ${D}/usr/share/terminfo/x
	mv xterm xterm.orig
	dosym xterm-color /usr/share/terminfo/x/xterm

	if [ -n "`use build`" ]
	then
		cd ${D}
		rm -rf usr/share/man
		cd usr/share/terminfo
		cp -a l/linux n/nxterm v/vt100 ${T}
		rm -rf *
		mkdir l x v
		cp -a ${T}/linux l
		cp -a ${T}/nxterm x/xterm
		cp -a ${T}/vt100 v
		cd ${D}/usr/lib
		#bash compilation requires static libncurses libraries, so
		#this breaks the "build a new build image" system.  We now
		#need to remove libncurses.a from the build image manually.
		#rm *.a
	else
		cd ${S}
		dodoc ANNOUNCE MANIFEST NEWS README* TO-DO
		dodoc doc/*.doc
		dohtml -r doc/html/
#		docinto html/ada
#		dodoc doc/html/ada/*.htm
#		docinto html/ada/files
#		dodoc doc/html/ada/files/*.htm
#		docinto html/ada/funcs
#		dodoc doc/html/ada/funcs/*.htm
#		docinto html/man
#		dodoc doc/html/man/*.html
	fi
}

