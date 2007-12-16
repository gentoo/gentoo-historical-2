# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hunit/hunit-1.1.1.ebuild,v 1.7 2007/12/16 19:00:11 nixnut Exp $

CABAL_FEATURES="lib profile haddock"
inherit base haskell-cabal

MY_PN="HUnit"
GHC_PV=6.6.1

DESCRIPTION="A unit testing framework for Haskell."
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~ia64 ppc sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${MY_PN}"

src_unpack() {
	unpack "${A}"
	cabal-mksetup
}

src_install () {
	cabal_src_install
	if use doc; then
		dohtml -r "${S}"/doc/*
	fi
}
