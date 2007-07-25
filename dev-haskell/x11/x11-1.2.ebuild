# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/x11/x11-1.2.ebuild,v 1.2 2007/07/25 18:38:18 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

MY_PN=X11
GHC_PV=6.6

DESCRIPTION="X11 bindings for haskell"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4
		x11-libs/libX11"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${MY_PN}"
