# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-Pg/DBD-Pg-1.32.ebuild,v 1.7 2004/12/29 10:09:20 corsair Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBD::Pg Module"
SRC_URI="http://cpan.org/modules/by-module/DBD/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/DBD/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~ppc64"

DEPEND="dev-perl/Test-Simple
	dev-perl/DBI
	dev-db/postgresql"

# env variables for compilation:
export POSTGRES_INCLUDE=/usr/include/postgresql/pgsql
export POSTGRES_LIB=/usr/lib/postgresql/

mydoc="Changes README"
