# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/parsec/parsec-2.1.0.0.ebuild,v 1.6 2008/07/15 06:02:16 jer Exp $

CABAL_FEATURES="lib profile haddock"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal

DESCRIPTION="Monadic parser combinators"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"
