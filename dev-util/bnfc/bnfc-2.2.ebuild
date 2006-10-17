# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bnfc/bnfc-2.2.ebuild,v 1.3 2006/10/17 20:46:42 dcoutts Exp $

inherit base ghc-package eutils

MY_PN="BNFC"

DESCRIPTION="BNF Converter -- a sophisticated parser generator"
HOMEPAGE="http://www.cs.chalmers.se/~markus/BNFC/"
SRC_URI="http://www.cs.chalmers.se/~markus/BNFC/${MY_PN}_${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="doc"

DEPEND=">=virtual/ghc-6.2
	doc? ( virtual/tetex )"

RDEPEND="virtual/libc"

S="${WORKDIR}/${MY_PN}_${PV}"

src_unpack() {
	base_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${P}-ghc66-utf8.patch"
}

src_compile() {
	emake GHC="$(ghc-getghc) -O" || die "emake failed"
	if use doc ; then
		cd doc
		pdflatex LBNF-report.tex
		pdflatex LBNF-report.tex
	fi
}

src_install() {
	dobin bnfc
	if use doc ; then
		cd doc
		dodoc LBNF-report.pdf
	fi
}
