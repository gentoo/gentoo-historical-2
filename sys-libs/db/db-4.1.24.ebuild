# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.1.24.ebuild,v 1.3 2002/10/23 18:19:06 gerk Exp $

IUSE="tcltk java"

S=${WORKDIR}/${P}/build_unix
DESCRIPTION="Berkeley DB"
SRC_URI="http://www.sleepycat.com/update/snapshot/${P}.tar.gz"
HOMEPAGE="http://www.sleepycat.com"
SLOT="4"
LICENSE="DB"
KEYWORDS="x86 -ppc sparc sparc64"

DEPEND="tcltk? ( dev-lang/tcl )
	java? ( virtual/jdk )"

src_compile() {

	local myconf

	use java \
		&& myconf="${myconf} --enable-java" \
		|| myconf="${myconf} --disable-java"

	use tcltk \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/lib" \
		|| myconf="${myconf} --disable-tcl"
	
	../dist/configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--enable-compat185 \
		--enable-cxx \
		--enable-posixmutexes \
		${myconf} || die

	emake || make || die
}

src_install () {

	einstall || die
	
	dodir /usr/share/doc/${PF}/html
	mv ${D}/usr/docs/* ${D}/usr/share/doc/${PF}/html/
}
