# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/zlib/zlib-0.4.0.1.ebuild,v 1.1 2007/12/15 18:38:45 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal

DESCRIPTION="Compression and decompression in the gzip and zlib formats"
HOMEPAGE="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/zlib"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

# works with ghc 6.4 too, but needs the fps package:
# 1) in DEPEND
# 2) in zlib.cabal

DEPEND=">=dev-lang/ghc-6.6
		>=sys-libs/zlib-1.2"
