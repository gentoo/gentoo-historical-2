# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
#
# $Header: /var/cvsroot/gentoo-x86/app-editors/e3/e3-1.7-r2.ebuild,v 1.12 2002/07/25 19:09:03 kabau Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Super Tiny Editor with wordstar, vi, and emacs key bindings"
SRC_URI="http://www.sax.de/~adlibit/${P}.tar.gz"
HOMEPAGE="http://www.sax.de/~adlibit"
DEPEND="dev-lang/nasm"
RDEPEND="sys-apps/sed"

SLOT="0"
LICENSE="GPL"
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
	if [ "`use build`" ]; then
		# easier-to-remember shell scripts
		dobin ${FILESDIR}/vi
		# this one is more trouble than its worth --woodchip
		# dobin ${FILESDIR}/emacs
		dobin ${FILESDIR}/pico
		newbin ${FILESDIR}/pico nano
	fi
	cp e3.man e3.1
	doman e3.1
}

