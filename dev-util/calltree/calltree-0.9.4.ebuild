# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/calltree/calltree-0.9.4.ebuild,v 1.2 2003/11/05 20:59:18 caleb Exp $

DESCRIPTION="A plugin for cachegrind that adds call-graph profiling, needed by kcachegrind"
HOMEPAGE="http://kcachegrind.sourceforge.net/"
SRC_URI="http://kcachegrind.sourceforge.net/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=dev-util/valgrind-1.9.6"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall
	rm -r ${D}/usr/share/doc/valgrind
	dodoc AUTHORS INSTALL README
	dohtml docs/*.html
}
