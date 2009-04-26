# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haddock/haddock-0.9.ebuild,v 1.2 2009/04/26 16:05:27 kolmodin Exp $

CABAL_FEATURES="bin"
inherit haskell-cabal eutils autotools

DESCRIPTION="A documentation tool for Haskell."
HOMEPAGE="http://haskell.org/haddock/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

DEPEND="<dev-lang/ghc-6.10
		>=dev-haskell/cabal-1.2
	doc? (  ~app-text/docbook-xml-dtd-4.2
			app-text/docbook-xsl-stylesheets
			>=dev-libs/libxslt-1.1.2 )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	if use doc; then
		cd "${S}/doc"
		eautoreconf
	fi
}

src_compile () {
	cabal_src_compile
	if use doc; then
		cd "${S}/doc"
		./configure --prefix="${D}/usr/" \
			|| die 'error configuring documentation.'
		emake html || die 'error building documentation.'
	fi
}

src_install () {
	cabal_src_install
	if use doc; then
		dohtml -r "${S}/doc/haddock/"* || die "installing docs failed"
	fi
	dodoc CHANGES README
}
