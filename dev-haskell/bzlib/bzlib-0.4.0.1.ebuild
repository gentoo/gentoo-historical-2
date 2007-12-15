# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/bzlib/bzlib-0.4.0.1.ebuild,v 1.1 2007/12/15 18:37:41 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal

DESCRIPTION="Compression and decompression in the bzip2 format"
HOMEPAGE="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/bzlib"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
		>=app-arch/bzip2-1.0"
