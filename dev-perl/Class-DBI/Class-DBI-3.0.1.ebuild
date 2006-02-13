# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-DBI/Class-DBI-3.0.1.ebuild,v 1.5 2006/02/13 10:55:23 mcummings Exp $

inherit perl-module

DESCRIPTION="Simple Database Abstraction"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 sparc x86"
IUSE=""

# Tests aren't possible since they require interaction with the DB's

DEPEND="dev-perl/Class-Data-Inheritable
		dev-perl/Class-Accessor
		dev-perl/Class-Trigger
		virtual/perl-File-Temp
		virtual/perl-Storable
		virtual/perl-Test-Simple
		virtual/perl-Scalar-List-Utils
		dev-perl/Ima-DBI
		dev-perl/UNIVERSAL-moniker"
