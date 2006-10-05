# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-Pg/DBD-Pg-1.42.ebuild,v 1.5 2006/10/05 21:49:50 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBD::Pg Module"
HOMEPAGE="http://cpan.org/modules/by-module/DBD/${P}.readme"
SRC_URI="mirror://cpan/authors/id/D/DB/DBDPG/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/perl-Test-Simple
	>=virtual/perl-Test-Harness-2.03
	>=dev-perl/DBI-1.35
	>=dev-db/postgresql-7.3
	dev-lang/perl"

# env variables for compilation:
export POSTGRES_INCLUDE=/usr/include/postgresql/pgsql
export POSTGRES_LIB=/usr/lib/postgresql/

mydoc="Changes README"
