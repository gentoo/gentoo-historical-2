# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bglibs/bglibs-1.011.ebuild,v 1.4 2004/02/22 20:00:46 agriffis Exp $

inherit fixheadtails

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips ~alpha amd64 ~hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	ht_fix_file ${S}/Makefile
	# fix weird bug with new gcc and compile of tests failing due to style of
	# gcc flags not on bugzilla, but personally reported to robbat2@gentoo.org
	# by personal friend
	sed -e 's|libraries selftests installer|libraries installer|g' -i ${S}/Makefile
}

src_compile() {
	echo "${D}/usr/lib/bglibs" > conf-home
	echo "${CC} ${CFLAGS}" > conf-cc
	echo "${CC} ${LDFLAGS}" > conf-ld
	# parallel builds fail badly
	MAKEOPTS="`echo ${MAKEOPTS} | sed -re 's/-j[[:digit:]]+//g'`" \
	emake || die
}

src_install () {
	dodir /usr/lib/bglibs
	./installer || die "install failed"
	dodoc ANNOUNCEMENT COPYING NEWS README ChangeLog TODO VERSION
	docinto html
	dodoc doc/html/*
	docinto latex
	dodoc doc/latex/*
}
