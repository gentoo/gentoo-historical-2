# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cook/cook-1.0.2.ebuild,v 1.6 2005/01/01 16:06:46 eradicator Exp $

DESCRIPTION="COOK is an embedded language which can be used as a macro preprocessor and for similar text processing."
HOMEPAGE="http://cook.sourceforge.net/"
SRC_URI="mirror://sourceforge/cook/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""
DEPEND="sys-libs/glibc"

src_compile() {
	cd ${S}
	emake
}

src_install() {
	cd ${S}
	dodoc README doc/cook.txt doc/cook.html
	dodir /usr/share/doc/${P}/example
	cd ${S}/test
	insinto /usr/share/doc/${P}/example
	doins pcb.dbdef pcb.dg pcbprol.ps tempsens.pcb
	cd ${S}
	dobin src/cook
}
