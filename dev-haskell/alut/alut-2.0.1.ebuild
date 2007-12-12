# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/alut/alut-2.0.1.ebuild,v 1.3 2007/12/12 09:52:07 opfer Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

MY_PN="ALUT"
GHC_PV=6.6.1

DESCRIPTION="A Haskell binding for the OpenAL Utility Toolkit"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
	>=dev-haskell/opengl-2.2.1
	>=dev-haskell/openal-1.3.1
	media-libs/freealut"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${MY_PN}"

# Sadly Setup.hs in the ghc-6.6.1 extralibs was not tested with Cabal-1.1.6.x
src_unpack() {
	unpack "${A}"
	sed -i -e "/type Hook/ s/UserHooks/Maybe UserHooks/" ${S}/Setup.hs
}

#TODO: install examples perhaps?
