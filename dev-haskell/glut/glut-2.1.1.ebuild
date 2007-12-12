# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glut/glut-2.1.1.ebuild,v 1.3 2007/12/12 09:58:52 opfer Exp $

CABAL_FEATURES="haddock lib profile"
inherit haskell-cabal

MY_PN=GLUT
GHC_PV=6.6.1

DESCRIPTION="GLUT bindings for haskell"
HOMEPAGE="http://www.haskell.org/HOpenGL/"
SRC_URI="http://www.haskell.org/ghc/dist/${GHC_PV}/ghc-${GHC_PV}-src-extralibs.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 x86"

# TODO: Install examples when the "examples" USE flag is set
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
	>=dev-haskell/opengl-2.2.1
	virtual/glu
	virtual/glut"

S="${WORKDIR}/ghc-${GHC_PV}/libraries/${MY_PN}"

# Sadly Setup.hs in the ghc-6.6.1 extralibs was not tested with Cabal-1.1.6.x
src_unpack() {
	unpack "${A}"
	sed -i -e "/type Hook/ s/UserHooks/Maybe UserHooks/" "${S}/Setup.hs"
}
