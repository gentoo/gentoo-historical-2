# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bglibs/bglibs-1.009.ebuild,v 1.5 2004/06/24 23:00:42 agriffis Exp $

inherit gcc

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	echo "${D}/usr/lib/bglibs" > conf-home
	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	emake -j1 || die
}

src_install () {
	dodir /usr/lib/bglibs
	./installer || die "install failed"
	dodoc ANNOUNCEMENT COPYING NEWS README
}
