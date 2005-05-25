# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-DBI/Apache-DBI-0.94.ebuild,v 1.10 2005/05/25 14:57:43 mcummings Exp $

inherit perl-module

DESCRIPTION="Apache::DBI module for perl"
SRC_URI="mirror://cpan/authors/id/A/AB/ABH/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~abh/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND="${DEPEND}
	perl-core/Test-Simple
	>=dev-perl/DBI-1.30"

export OPTIMIZE="$CFLAGS"
