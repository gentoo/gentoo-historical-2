# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/pgf/pgf-0.60.ebuild,v 1.1 2004/02/21 20:57:47 usata Exp $

inherit latex-package

DESCRIPTION="pgf -- The TeX Portable Graphic Format"
HOMEPAGE="http://latex-beamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex-beamer/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND="virtual/tetex"
S="${WORKDIR}/${PN}"

src_compile() {

	return
}

src_install() {

	latex-package_src_install || die

	dodoc AUTHORS ChangeLog FILES README TODO
	insinto /usr/share/doc/${PF}
	doins *.jpg *.pdf *.eps
}
