# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-sci/xdrawchem/xdrawchem-1.5.ebuild,v 1.5 2003/02/13 09:27:00 vapier Exp $

IUSE="qt"

S=${WORKDIR}/${P}
DESCRIPTION="XDrawChem--a molecular structure drawing program."
SRC_URI="http://www.prism.gatech.edu/~gte067k/${PN}/${P}.tgz"
HOMEPAGE="http://www.prism.gatech.edu/~gte067k/${PN}"

KEYWORDS="x86 ~ppc ~sparc "
SLOT="0"
LICENSE="GPL-2"

DEPEND="qt? ( >=qt-3.0.0 )"

#the app requires babel at run time to be able to perform various file type conversions
RDEPEND="${DEPEND}
	app-sci/babel"

src_compile() {
	emake -f Makefile.orig INSTRING=/usr/share/${P} || die
}

src_install () {
	dodir /usr/bin
	dobin xdrawchem

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins ring/*

	dodoc README.txt TODO.txt COPYRIGHT.txt HISTORY.txt
}

