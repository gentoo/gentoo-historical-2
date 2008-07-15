# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-MIME/Email-MIME-1.861.ebuild,v 1.2 2008/07/15 18:21:39 armin76 Exp $

inherit perl-module

DESCRIPTION="Easy MIME message parsing"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ia64 ~ppc ~ppc64 sparc x86"

DEPEND="virtual/perl-Test-Simple
	>=dev-perl/Email-MIME-Encodings-1.310
	>=dev-perl/Email-MIME-ContentType-1.012
	dev-perl/Email-Simple
	>=dev-perl/MIME-Types-1.18
	dev-lang/perl"

SRC_TEST="do"
