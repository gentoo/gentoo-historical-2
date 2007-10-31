# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hdbc/hdbc-1.0.0.ebuild,v 1.2 2007/10/31 13:00:06 dcoutts Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Haskell Database Connectivity"
HOMEPAGE="http://quux.org/devel/hdbc/"
SRC_URI="http://quux.org/devel/hdbc/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="odbc postgres sqlite"

DEPEND=">=dev-lang/ghc-6.4.1"

PDEPEND="odbc? ( =dev-haskell/hdbc-odbc-${PV}* )
		 postgres? ( =dev-haskell/hdbc-postgresql-${PV}* )
		 sqlite? ( =dev-haskell/hdbc-sqlite-${PV}* )"

S="${WORKDIR}/${PN}"
