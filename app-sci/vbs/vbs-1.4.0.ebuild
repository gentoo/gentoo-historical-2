# Copyright 1999-2004 Gentoo Foundation and Tim Yamin <plasmaroo@gentoo.org> <plasmaroo@squirrelsoft.org.uk>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/vbs/vbs-1.4.0.ebuild,v 1.4 2004/06/24 22:20:21 agriffis Exp $

HOMEPAGE="http://www.geda.seul.org/tools/vbs/index.html"
DESCRIPTION="vbs - the Verilog Behavioral Simulator"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~x86 ~ppc"

DEPEND=">=sys-devel/flex-2.3
	>=sys-devel/bison-1.22"

src_compile () {

	cd src
	econf || die
	emake vbs || die

}

src_install () {

	dodoc BUGS CONTRIBUTORS COPYRIGHT FAQ README vbs.txt

	docinto examples
	dodoc EXAMPLES/*

	exeinto /usr/bin
	doexe src/vbs

}
