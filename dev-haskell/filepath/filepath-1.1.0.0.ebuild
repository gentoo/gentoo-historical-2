# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/filepath/filepath-1.1.0.0.ebuild,v 1.3 2008/07/06 20:53:10 maekke Exp $

CABAL_FEATURES="haddock lib profile"
inherit haskell-cabal

DESCRIPTION="Library for manipulating FilePath's in a cross platform way."
HOMEPAGE="http://www-users.cs.york.ac.uk/~ndm/projects/libraries.php"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~alpha amd64 ~ia64 ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"

CABAL_CORE_LIB_GHC_PV="6.8.1 6.8.2"
