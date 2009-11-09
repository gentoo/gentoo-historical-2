# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/iconv/iconv-0.4.0.2.ebuild,v 1.1 2009/11/09 18:59:23 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="String encoding conversion"
HOMEPAGE="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/iconv"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2.1"

src_unpack() {
	unpack ${A}

	sed -e 's/^library/library\n  build-depends: base < 4/' \
	  -i "${S}/${PN}.cabal"
}
