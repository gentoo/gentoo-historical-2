# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Date/Email-Date-1.101.ebuild,v 1.1 2007/02/05 20:11:42 mcummings Exp $

inherit perl-module

DESCRIPTION="No description available"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86 ~sparc"

DEPEND="virtual/perl-Test-Simple
	>=dev-perl/Email-Abstract-2.13.1
	dev-perl/Time-Piece
	dev-perl/Email-Simple
	virtual/perl-Time-Local
	>=dev-perl/TimeDate-1.16
	dev-lang/perl"

SRC_TEST="do"
