# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/x11/x11-1.4.6.1.ebuild,v 1.1 2009/10/26 22:19:50 kolmodin Exp $

CABAL_FEATURES="lib profile haddock hscolour"
inherit haskell-cabal

MY_PN="X11"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A binding to the X11 graphics library"
HOMEPAGE="http://darcs.haskell.org/X11"
SRC_URI="http://hackage.haskell.org/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="xinerama"

DEPEND=">=dev-haskell/cabal-1.2"
RDEPEND="${DEPEND}
		>=dev-lang/ghc-6.8
		x11-libs/libX11
		xinerama? ( x11-libs/libXinerama )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	CABAL_CONFIGURE_FLAGS="--configure-option=$(use_with xinerama)"
	cabal_src_compile
}

