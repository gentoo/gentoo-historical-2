# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cgi/cgi-2006.9.6.ebuild,v 1.1 2007/03/17 14:31:56 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

GHC_PV=6.6

DESCRIPTION="A haskell library for writing CGI programs"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/ghc-6.6
	>=dev-haskell/mtl-1.0
	>=dev-haskell/xhtml-2006.9.13
	>=dev-haskell/network-2.0"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${PN}"

