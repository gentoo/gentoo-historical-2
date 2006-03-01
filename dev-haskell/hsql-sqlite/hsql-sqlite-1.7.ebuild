# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hsql-sqlite/hsql-sqlite-1.7.ebuild,v 1.3 2006/03/01 19:41:36 hansmi Exp $

CABAL_FEATURES="lib haddock"
inherit base haskell-cabal

DESCRIPTION="SQLite3 driver HSQL"
HOMEPAGE="http://htoolkit.sourceforge.net/"
SRC_URI="mirror://gentoo/HSQL-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=virtual/ghc-6.4.1
	~dev-haskell/hsql-${PV}
	>=dev-db/sqlite-3.0"

S="${WORKDIR}/HSQL/SQLite3"

src_unpack() {
	base_src_unpack

	echo '> import Distribution.Simple' > "${S}/Setup.lhs"
	echo '> main = defaultMain' >> "${S}/Setup.lhs"

	echo 'extra-libraries: sqlite3' >> "${S}/SQLite3.cabal"
}
