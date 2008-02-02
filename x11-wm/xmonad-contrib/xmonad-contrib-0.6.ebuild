# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/xmonad-contrib/xmonad-contrib-0.6.ebuild,v 1.1 2008/02/02 19:09:25 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"

inherit haskell-cabal

DESCRIPTION="Third party extentions for xmonad"
HOMEPAGE="http://www.xmonad.org/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND="dev-haskell/mtl
	~x11-wm/xmonad-${PV}
	>=dev-lang/ghc-6.6
	>=dev-haskell/x11-1.4.1
	>=dev-haskell/cabal-1.2.1"
RDEPEND="${DEPEND}"

src_compile() {
	CABAL_CONFIGURE_FLAGS="--flags=-use_xft"
	cabal_src_compile
}
