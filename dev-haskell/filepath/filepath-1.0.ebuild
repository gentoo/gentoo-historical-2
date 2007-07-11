# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/filepath/filepath-1.0.ebuild,v 1.2 2007/07/11 18:10:25 dcoutts Exp $

CABAL_FEATURES="haddock lib"
inherit haskell-cabal

DESCRIPTION="Utilities for filepath handling."
HOMEPAGE="http://www-users.cs.york.ac.uk/~ndm/projects/libraries.php"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

#if possible try testing with "~ppc" and "~sparc"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

DEPEND=">=virtual/ghc-6.4"
