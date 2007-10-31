# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/missingh/missingh-0.14.4.ebuild,v 1.3 2007/10/31 13:08:35 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit base haskell-cabal

DESCRIPTION="Collection of Haskell-related utilities"
HOMEPAGE="http://quux.org/devel/missingh"
SRC_URI="http://quux.org/devel/missingh/missingh_${PV}.tar.gz"

LICENSE="GPL-2" # mixed licence, mostly GPL
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

S="${WORKDIR}/missingh"

DEPEND=">=dev-lang/ghc-6.4.1"

src_unpack() {
	base_src_unpack

	# removes warning with later versions of cabal
	sed -i -e "s/HS-Source-Dir/HS-Source-Dirs/" "${S}/MissingH.cabal"

	# change -O2 to -O
	sed -i -e "s/GHC-Options: -O2/GHC-Options: -O/" "${S}/MissingH.cabal"
}

src_install() {
	cabal_src_install
	dodoc README COPYRIGHT
}
