# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-MIME/Email-MIME-1.857.ebuild,v 1.2 2007/02/05 20:01:15 mcummings Exp $

inherit perl-module

DESCRIPTION="Easy MIME message parsing"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86 ~sparc"

DEPEND="virtual/perl-Test-Simple
	>=dev-perl/Email-MIME-Encodings-1.310
	>=dev-perl/Email-MIME-ContentType-1.012
	dev-perl/Email-Simple
	>=dev-perl/MIME-Types-1.18
	dev-lang/perl"

SRC_TEST="do"
