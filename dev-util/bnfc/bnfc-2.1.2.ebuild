# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bnfc/bnfc-2.1.2.ebuild,v 1.6 2008/07/07 18:44:24 kolmodin Exp $

DESCRIPTION="BNF Converter -- a sophisticated parser generator"
HOMEPAGE="http://www.cs.chalmers.se/~markus/BNFC/"
SRC_URI="http://www.cs.chalmers.se/~markus/BNFC/${PN}_${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="doc"

DEPEND=">=dev-lang/ghc-6.2
	!>=dev-lang/ghc-6.6
	doc? ( virtual/latex-base )"

RDEPEND="virtual/libc"

S="${WORKDIR}/BNFC"

src_compile() {
	emake GHC_OPTS=-O || die "emake failed"
}

src_install() {
	dobin bnfc
	if use doc ; then
		cd doc
		pdflatex LBNF-report.tex
		pdflatex LBNF-report.tex
		insinto "/usr/share/doc/${P}"
		doins LBNF-report.pdf
	fi
}
