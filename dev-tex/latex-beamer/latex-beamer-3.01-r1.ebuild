# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex-beamer/latex-beamer-3.01-r1.ebuild,v 1.1 2005/11/28 18:12:28 nattfodd Exp $

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector."
HOMEPAGE="http://latex-beamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex-beamer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc-macos ~sparc ~x86"

IUSE=""

DEPEND=">=dev-tex/pgf-0.64
	>=dev-tex/xcolor-2.00
	!>=app-text/tetex-3.0"
S="${WORKDIR}/beamer"

src_compile() {

	return
}

src_install() {

	dodir /usr/share/texmf/tex/latex/beamer
	cp -pPR base extensions solutions themes \
		${D}/usr/share/texmf/tex/latex/beamer || die

	insinto /usr/share/texmf/tex/latex/beamer/emulation
	doins emulation/*.sty || die

	for dir in examples emulation/examples ; do
		insinto /usr/share/doc/${PF}/$dir
		doins $dir/*
	done

	if has_version 'app-office/lyx' ; then
		cp -pPR lyx ${D}/usr/share/doc/${PF}
	fi

	dodoc AUTHORS ChangeLog FILES TODO README
	insinto /usr/share/doc/${PF}
	doins doc/*
}
