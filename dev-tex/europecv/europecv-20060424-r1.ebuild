# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/europecv/europecv-20060424-r1.ebuild,v 1.2 2008/09/04 06:16:28 aballier Exp $

inherit latex-package

DESCRIPTION="LaTeX class for the standard model for curricula vitae as recommended by the European Commission."
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/europecv.html"
# Downloaded from:
# ftp://cam.ctan.org/tex-archive/macros/latex/contrib/europecv.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="examples"

RDEPEND="|| ( dev-texlive/texlive-latexrecommended dev-tex/latex-unicode )"
DEPEND="${RDEPEND}
	app-arch/unzip"
S="${WORKDIR}/${PN}"

TEXMF=/usr/share/texmf-site

src_compile() {
	return
}

src_install() {
	insinto ${TEXMF}/tex/latex/europecv
	doins ecv* europecv.cls EuropeFlag* europasslogo*

	insinto /usr/share/doc/${PF}
	doins -r europecv.pdf europecv.tex
	dosym /usr/share/doc/${PF}/europecv.pdf	${TEXMF}/doc/latex/${PN}/europecv.pdf
	use examples && doins -r examples templates
}
