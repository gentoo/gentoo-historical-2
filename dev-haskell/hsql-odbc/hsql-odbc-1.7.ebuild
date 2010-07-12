# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hsql-odbc/hsql-odbc-1.7.ebuild,v 1.8 2010/07/12 15:48:39 slyfox Exp $

CABAL_FEATURES="lib haddock"
inherit haskell-cabal versionator

DESCRIPTION="ODBC driver for HSQL"
HOMEPAGE="http://htoolkit.sourceforge.net/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4.1
	~dev-haskell/hsql-${PV}
	>=dev-db/unixODBC-2.2"

CABAL_CONFIGURE_FLAGS="--constraint=base<4"

src_unpack() {
	unpack ${A}

	cabal-mksetup
	sed -i -e  '/cc-options:/d' "${S}/${PN}.cabal"
	echo 'extra-libraries: odbc' >> "${S}/${PN}.cabal"
	echo 'include-dirs: Database/HSQL' >> "${S}/${PN}.cabal"

	# Add in the extra split-base deps
	if version_is_at_least "6.8" "$(ghc-version)"; then
		echo "build-depends: old-time" >> "${S}/${PN}.cabal"
	fi
}
