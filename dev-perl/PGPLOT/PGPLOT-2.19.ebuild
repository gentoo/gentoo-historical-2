# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PGPLOT/PGPLOT-2.19.ebuild,v 1.9 2008/07/13 21:27:53 robbat2 Exp $

inherit perl-module

DESCRIPTION="allow subroutines in the PGPLOT graphics library to be called from Perl."
HOMEPAGE="http://search.cpan.org/~kgb/"
SRC_URI="mirror://cpan/authors/id/K/KG/KGB/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

# Tests require active X display
#SRC_TEST="do"

DEPEND="sci-libs/pgplot
	>=dev-perl/ExtUtils-F77-1.13
	dev-lang/perl"
