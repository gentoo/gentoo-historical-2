# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/xhtml/xhtml-2006.9.13.ebuild,v 1.1 2007/03/17 14:11:19 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

GHC_PV=6.6

DESCRIPTION="XHTML combinator library for haskell"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/ghc-6.6"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${PN}"
