# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hdbc/hdbc-1.0.1.ebuild,v 1.1 2007/07/11 17:39:02 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Haskell Database Connectivity"
HOMEPAGE="http://quux.org/devel/hdbc/"
SRC_URI="http://quux.org/devel/hdbc/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="odbc postgres sqlite"

DEPEND=">=virtual/ghc-6.4.1
	>=dev-haskell/mtl-1.0"

PDEPEND="odbc? ( =dev-haskell/hdbc-odbc-${PV}* )
		 postgres? ( =dev-haskell/hdbc-postgresql-${PV}* )
		 sqlite? ( =dev-haskell/hdbc-sqlite-${PV}* )"

S="${WORKDIR}/${PN}"
