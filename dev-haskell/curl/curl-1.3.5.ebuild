# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/curl/curl-1.3.5.ebuild,v 1.1 2010/03/08 23:42:26 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Haskell binding to libcurl"
HOMEPAGE="http://hackage.haskell.org/cgi-bin/hackage-scripts/package/curl"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6.1
		>=dev-haskell/cabal-1.2
		net-misc/curl"
