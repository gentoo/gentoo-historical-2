# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/zlib/zlib-1.1.4-r3.ebuild,v 1.5 2004/07/02 08:51:23 eradicator Exp $

inherit eutils flag-o-matic

S="${WORKDIR}/${P}"
DESCRIPTION="Standard (de)compression library"
SRC_URI="http://www.gzip.org/zlib/${P}.tar.bz2"
HOMEPAGE="http://www.gzip.org/zlib"

LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86 ppc ~sparc ~alpha ~mips ~hppa ~ia64"
SLOT="0"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Updated security patch
	epatch ${FILESDIR}/${P}-gzprintf.patch

	# Make sure we link with glibc at all times
	epatch ${FILESDIR}/${P}-glibc.patch
	# Needed for Alpha and prelink
	epatch ${FILESDIR}/${P}-build-fPIC.patch
}

src_compile() {
	./configure --shared --prefix=/usr || die
	emake || die
	make test || die

	./configure --prefix=/usr || die
	emake || die
}

src_install() {
	into /usr
	dodir /usr/include
	insinto /usr/include
	doins zconf.h zlib.h

	dolib libz.so.${PV}
	( cd ${D}/usr/lib ; chmod 755 libz.so.* )
	dolib libz.a
	dosym libz.so.${PV} /usr/lib/libz.so
	dosym libz.so.${PV} /usr/lib/libz.so.1

	doman zlib.3
	dodoc FAQ README ChangeLog
	docinto txt
	dodoc algorithm.txt
}
