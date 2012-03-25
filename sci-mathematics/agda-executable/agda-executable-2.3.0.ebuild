# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/agda-executable/agda-executable-2.3.0.ebuild,v 1.1 2012/03/25 14:09:18 gienah Exp $

EAPI="3"

CABAL_FEATURES="bin"
inherit haskell-cabal eutils

MY_PN="Agda-executable"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command-line program for type-checking and compiling Agda programs"
HOMEPAGE="http://wiki.portal.chalmers.se/agda/"
SRC_URI="http://hackage.haskell.org/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		~sci-mathematics/agda-2.3.0
		>=dev-haskell/cabal-1.8
		>=dev-lang/ghc-6.8.2"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cabal-mksetup
}
