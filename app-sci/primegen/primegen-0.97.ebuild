# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/primegen/primegen-0.97.ebuild,v 1.2 2003/03/13 19:57:02 george Exp $

IUSE=""

DESCRIPTION="A small, fast library to generate primes in order"
HOMEPAGE="http://cr.yp.to/primegen.html"
SRC_URI="http://cr.yp.to/primegen/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc"

src_compile() {
	echo ${CC} ${CFLAGS} > conf-cc
	echo /usr > conf-home
	echo ${CC} ${CFLAGS} > conf-ld
	emake || die
}

src_install() {
	dobin primegaps primes primespeed
	doman primegaps.1 primes.1 primespeed.1
	doman error.3 error_str.3 primegen.3
	dolib.a primegen.a
	insinto /usr/include
	doins primegen.h uint32.h uint64.h
	dodoc BLURB CHANGES README
}
