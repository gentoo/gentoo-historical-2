# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/eurosym/eurosym-1.4.ebuild,v 1.8 2008/09/03 05:04:56 aballier Exp $

inherit latex-package

S=${WORKDIR}/${PN}

DESCRIPTION="LaTeX package and fonts used to set the euro (currency) symbol."
# Snapshot taken from: ftp://ftp.dante.de/tex-archive/fonts/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/eurosym.html"
LICENSE="as-is"

IUSE=""
SLOT="0"
KEYWORDS="alpha ppc sparc x86"

# >=tetex-2 contains eurosym package
RDEPEND="!>=app-text/tetex-2
	!app-text/ptex
	!dev-texlive/texlive-fontsrecommended"

SUPPLIER="public"

src_install() {

	dodoc README Changes

	cd ${S}/tfm
	latex-package_src_doinstall all
	cd ${S}/sty
	latex-package_src_doinstall all

	cd ${S}
	insinto ${TEXMF}/fonts/type1/${SUPPLIER}/${PN}
	doins contrib/type1/fonts/type1/eurosym/*
	insinto ${TEXMF}/dvips/config/
	doins contrib/type1/dvips/config/eurosym.map
	insinto ${TEXMF}/fonts/source/${SUPPLIER}/${PN}
	doins src/*.mf

	cd ${S}/doc
	dodoc *

}
