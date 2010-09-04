# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wxcore/wxcore-0.12.1.6.ebuild,v 1.1 2010/09/04 13:59:36 kolmodin Exp $

EAPI="2"

WX_GTK_VER="2.8"

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal wxwidgets

DESCRIPTION="wxHaskell core"
HOMEPAGE="http://haskell.org/haskellwiki/WxHaskell"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/parsec
		dev-haskell/stm
		dev-haskell/time
		>=dev-haskell/wxdirect-0.12.1.3
		>=dev-lang/ghc-6.10
		x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
