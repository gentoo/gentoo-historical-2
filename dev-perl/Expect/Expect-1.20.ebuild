# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Expect/Expect-1.20.ebuild,v 1.3 2007/01/15 17:41:34 mcummings Exp $

inherit perl-module

DESCRIPTION="Expect for Perl"
HOMEPAGE="http://search.cpan.org/~rgiersig/"
SRC_URI="mirror://cpan/authors/id/R/RG/RGIERSIG/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/IO-Tty-1.03
	dev-lang/perl"
