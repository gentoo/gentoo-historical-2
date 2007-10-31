# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hxt/hxt-6.0.ebuild,v 1.2 2007/10/31 13:07:44 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit base haskell-cabal

MY_PN="HXT"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A collection of tools for processing XML with Haskell"
HOMEPAGE="http://www.fh-wedel.de/~si/HXmlToolbox/"
SRC_URI="http://www.fh-wedel.de/~si/HXmlToolbox/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4
		dev-haskell/http"

S=${WORKDIR}/${MY_P}

src_unpack() {
	base_src_unpack

	sed -i \
		-e 's/, Browser//' \
		-e 's/-O2/-O/' \
		"${S}/hxt.cabal"
}

src_install() {
	cabal_src_install

	dodoc LICENSE README
	if use doc; then
		cd ${S}/doc
		dodoc thesis.ps
		dohtml -r *
	fi
}
