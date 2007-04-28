# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/plptools/plptools-0.11-r1.ebuild,v 1.11 2007/04/28 17:57:07 swegener Exp $

DESCRIPTION="Libraries and utilities to communicate with a Psion palmtop via serial."
HOMEPAGE="http://plptools.sourceforge.net"
SRC_URI="mirror://sourceforge/plptools/${P}.tar.gz"
LICENSE="as-is"

SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	patch -p1 < ${FILESDIR}/${P}-gentoo.patch || die "Patch failed!"

	local myconf

	myconf="${myconf} --disable-kde"

	./configure ${myconf} --prefix=/usr || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc CHANGES README TODO

	newconfd ${FILESDIR}/psion.conf psion

	doinitd ${FILESDIR}/psion
}
