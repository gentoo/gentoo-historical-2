# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-DBI/Apache-DBI-0.94.ebuild,v 1.15 2006/08/04 22:16:35 mcummings Exp $

inherit perl-module

DESCRIPTION="Apache::DBI module for perl"
SRC_URI="mirror://cpan/authors/id/A/AB/ABH/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~abh/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND="virtual/perl-Test-Simple
	>=dev-perl/DBI-1.30
	dev-lang/perl"
RDEPEND="${DEPEND}"

export OPTIMIZE="$CFLAGS"
