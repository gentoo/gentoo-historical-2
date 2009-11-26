# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hinotify/hinotify-0.3.ebuild,v 1.1 2009/11/26 21:24:10 kolmodin Exp $

CABAL_FEATURES="lib haddock profile"
inherit haskell-cabal

DESCRIPTION="Haskell binding to INotify"
HOMEPAGE="http://haskell.org/~kolmodin/code/hinotify/README.html"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6.1"
RDEPEND=">=dev-lang/ghc-6.6.1"
