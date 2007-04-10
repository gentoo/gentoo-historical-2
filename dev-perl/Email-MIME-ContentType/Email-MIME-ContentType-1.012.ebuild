# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-MIME-ContentType/Email-MIME-ContentType-1.012.ebuild,v 1.6 2007/04/10 12:12:50 mcummings Exp $

inherit perl-module

DESCRIPTION="Parse a MIME Content-Type Header"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 sparc ~x86"

DEPEND="dev-lang/perl"

SRC_TEST="do"
