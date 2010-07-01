# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/happy/happy-1.17.ebuild,v 1.6 2010/07/01 19:56:36 jer Exp $

CABAL_FEATURES="bin"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal autotools

DESCRIPTION="A yacc-like parser generator for Haskell"
HOMEPAGE="http://haskell.org/happy/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="doc"

DEPEND=">=dev-lang/ghc-6.4
		dev-haskell/mtl
	doc? (  ~app-text/docbook-xml-dtd-4.2
		app-text/docbook-xsl-stylesheets )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	sed -e "s/BuildFlags(..)/BuildFlags(..), buildVerbose/" \
		-i "${S}/Setup.lhs"
	cd "${S}/doc" && eautoconf
}

src_compile() {
	cabal_src_compile
	if use doc; then
		cd doc
		econf || die "econf failed in /doc"
		emake -j1 || die "emake failed in /doc"
	fi
}

src_install() {
	cabal_src_install
	use doc && cd doc && dohtml -r happy/*
}
