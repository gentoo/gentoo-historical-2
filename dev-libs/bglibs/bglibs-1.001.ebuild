# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/bglibs/bglibs-1.001.ebuild,v 1.5 2002/12/09 04:21:02 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Bruce Guenters library package"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

src_compile() {
	echo "${D}/usr/lib/bglibs" > conf-home
	echo "gcc ${CFLAGS}" > conf-cc
	MAKEOPTS="" emake || die
}

src_install () {
	dodir /usr/lib/bglibs
	./installer || die "install failed"
}
