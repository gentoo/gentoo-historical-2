# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/dbix-searchbuilder/dbix-searchbuilder-1.35.ebuild,v 1.3 2006/01/13 20:40:46 mcummings Exp $

inherit perl-module

MY_P=DBIx-SearchBuilder-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Encapsulate SQL queries and rows in simple perl objects"
SRC_URI="mirror://cpan/authors/id/J/JE/JESSE/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/J/JE/JESSE/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
#KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
KEYWORDS="sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/DBD-SQLite
		>=perl-core/Test-Simple-0.52"

RDEPEND="dev-perl/DBI
		dev-perl/DBIx-DBSchema
		dev-perl/Want
		dev-perl/Cache-Simple-TimedExpiry
		dev-perl/Clone
		dev-perl/Class-Accessor
		dev-perl/capitalization
		>=dev-perl/class-returnvalue-0.4"
