# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
#
# $Header: /var/cvsroot/gentoo-x86/app-editors/e3/e3-1.7.ebuild,v 1.8 2002/10/04 04:04:25 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Super Tiny Editor with wordstar, vi, and emacs key bindings"
SRC_URI="http://www.sax.de/~adlibit/${P}.tar.gz"
HOMEPAGE="http://www.sax.de/~adlibit"
DEPEND="dev-lang/nasm"
RDEPEND=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc -sparc64"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	emake || die
}

src_install () {
	dodir /usr/bin
	dobin e3
	dosym e3 /usr/bin/e3vi
	dosym e3 /usr/bin/e3em
	dosym e3 /usr/bin/e3ws
	dosym e3 /usr/bin/e3pi
	dosym e3 /usr/bin/e3ne

	cp e3.man e3.1
	doman e3.1
}

