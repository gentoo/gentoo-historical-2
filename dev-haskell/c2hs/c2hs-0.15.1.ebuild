# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/c2hs/c2hs-0.15.1.ebuild,v 1.2 2010/04/11 18:27:53 armin76 Exp $

CABAL_FEATURES="bin"
CABAL_MIN_VERSION=1.2
inherit base eutils haskell-cabal

DESCRIPTION="An interface generator for Haskell"
HOMEPAGE="http://www.cse.unsw.edu.au/~chak/haskell/c2hs/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND=">=dev-lang/ghc-6.4
		dev-haskell/filepath"

src_install() {
	cabal_src_install

	if use doc; then
		doman "${S}/doc/man1/c2hs.1"
		dohtml "${S}/doc/users_guide/"*
	fi
}
