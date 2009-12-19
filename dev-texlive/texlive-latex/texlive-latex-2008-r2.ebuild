# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-latex/texlive-latex-2008-r2.ebuild,v 1.2 2009/12/19 20:27:28 pacho Exp $

TEXLIVE_MODULE_CONTENTS="ae amscls amsmath amsrefs babel babelbib carlisle colortbl fancyhdr geometry graphics hyperref latex latex-fonts latexconfig ltxmisc mfnfss natbib pdftex-def pslatex psnfss pspicture tools bin-latex luatex pdftex collection-latex
"
TEXLIVE_MODULE_DOC_CONTENTS="ae.doc amscls.doc amsmath.doc amsrefs.doc babel.doc babelbib.doc carlisle.doc colortbl.doc fancyhdr.doc geometry.doc graphics.doc hyperref.doc latex.doc natbib.doc psnfss.doc pspicture.doc tools.doc bin-latex.doc luatex.doc pdftex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ae.source amscls.source amsmath.source amsrefs.source babel.source babelbib.source carlisle.source colortbl.source geometry.source graphics.source hyperref.source latex.source mfnfss.source natbib.source pslatex.source psnfss.source pspicture.source tools.source "
inherit texlive-module eutils
DESCRIPTION="TeXLive Basic LaTeX packages"

LICENSE="GPL-2 as-is freedist GPL-1 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008-r1
dev-tex/luatex
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf/scripts/simpdftex/simpdftex"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-luatex-0.40.patch"
}
