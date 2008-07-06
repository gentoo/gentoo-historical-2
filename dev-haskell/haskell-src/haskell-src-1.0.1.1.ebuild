# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haskell-src/haskell-src-1.0.1.1.ebuild,v 1.2 2008/07/06 20:35:11 maekke Exp $

CABAL_FEATURES="lib profile haddock happy"
CABAL_MIN_VERSION=1.2
inherit base haskell-cabal

DESCRIPTION="Haskell source library"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"
