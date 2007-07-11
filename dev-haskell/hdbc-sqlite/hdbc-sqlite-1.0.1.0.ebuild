# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hdbc-sqlite/hdbc-sqlite-1.0.1.0.ebuild,v 1.1 2007/07/11 17:40:15 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit base haskell-cabal versionator

DESCRIPTION="Sqlite v3 database driver for HDBC"
HOMEPAGE="http://quux.org/devel/hdbc/"
SRC_URI="http://quux.org/devel/hdbc/${PN}3_${PV}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~sparc"
IUSE=""

hdbc_PV=$(get_version_component_range 1-3)

DEPEND=">=virtual/ghc-6.4.1
	~dev-haskell/hdbc-${hdbc_PV}
	>=dev-db/sqlite-3.2"

S="${WORKDIR}/${PN}3"

src_unpack() {
	base_src_unpack

	# Fix haddock markup
	sed -i -e 's|execute/fetchrow|execute\\/fetchrow|' \
		"${S}/Database/HDBC/Sqlite3/Statement.hsc"
}
