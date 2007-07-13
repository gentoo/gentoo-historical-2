# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/otter/otter-3.3-r1.ebuild,v 1.4 2007/07/13 05:28:09 mr_bones_ Exp $

DESCRIPTION="An Automated Deduction System."
SRC_URI="http://www-unix.mcs.anl.gov/AR/${PN}/${P}.tar.gz"
HOMEPAGE="http://www-unix.mcs.anl.gov/AR/otter/"

KEYWORDS="~amd64 ~ppc ~ppc-macos x86"
LICENSE="otter"
SLOT="0"
IUSE=""
DEPEND="virtual/libc"

src_compile() {
	cd source
	make || die
	cd ${S}/mace2
	make || die
}

src_install() {
	dobin bin/* source/formed/formed
	dodoc README* Legal Changelog Contents documents/*.{tex,ps}
	insinto /usr/share/doc/${PF}
	doins documents/*.pdf
	dohtml index.html
	insinto /usr/share/doc/${PF}/html
	doins -r examples examples-mace2
}
