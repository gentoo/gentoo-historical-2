# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-Pg/DBD-Pg-1.32.ebuild,v 1.10 2005/05/25 15:04:13 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBD::Pg Module"
SRC_URI="mirror://cpan/authors/id/R/RU/RUDY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rudy/${P}"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ppc64"

DEPEND="perl-core/Test-Simple
	dev-perl/DBI
	dev-db/postgresql"

# env variables for compilation:
export POSTGRES_INCLUDE=/usr/include/postgresql/pgsql
export POSTGRES_LIB=/usr/lib/postgresql/

mydoc="Changes README"
