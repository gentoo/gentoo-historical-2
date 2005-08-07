# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tcllib/tcllib-1.6.1.ebuild,v 1.8 2005/08/07 13:00:26 hansmi Exp $

DESCRIPTION="Tcl Standard Library."
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="mirror://sourceforge/tcllib/${P}.tar.gz"
IUSE="X doc"
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc s390 sparc x86"

DEPEND=">=dev-lang/tcl-8.3.3
	X? ( >=dev-lang/tk-8.3.3 )"

src_compile() {
	econf || die
	make || die
}

src_install() {
	einstall || die
	dodoc ChangeLog README license.terms
	use doc && dohtml -r doc/html/*
}
