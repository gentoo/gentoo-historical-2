# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/icerrun/icerrun-0.5.ebuild,v 1.5 2004/08/03 11:26:09 dholm Exp $

DESCRIPTION="IceWM 'recently used programs' menu generator"
SRC_URI="mirror://sourceforge/icecc/${P}.tar.bz2"
HOMEPAGE="http://icecc.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
RESTRICT="nostrip"
IUSE=""

DEPEND=">=dev-lang/python-2.0"

SLOT="0"

src_compile () {
	einfo "No compilation necessary"
}

src_install () {
	exeinto /usr/bin
	doexe *.py
	dodoc README*
}
