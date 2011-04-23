# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/json/json-0.4.3.ebuild,v 1.4 2011/04/23 15:33:14 slyfox Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Support for serialising Haskell to and from JSON"
HOMEPAGE="http://hackage.haskell.org/package/json"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

# TODO: look into adding dep syb and allow other ghc versions
# syb is a core package of ghc-6.10.1, and was previously included in base

# enable map to dict?

RDEPEND=">=dev-lang/ghc-6.10
		>=dev-haskell/cabal-1.2.0
		dev-haskell/mtl
		dev-haskell/parsec"

DEPEND="${RDEPEND}"
