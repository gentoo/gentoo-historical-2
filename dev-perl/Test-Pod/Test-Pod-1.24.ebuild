# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Pod/Test-Pod-1.24.ebuild,v 1.5 2006/07/10 15:42:31 mcummings Exp $

inherit perl-module

DESCRIPTION="check for POD errors in files"
HOMEPAGE="http://search.cpan.org/~petdance/${P}"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"

SRC_TEST="do"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86"
IUSE=""

DEPEND="dev-perl/Pod-Simple
	 	>=virtual/perl-Test-Simple-0.62"
RDEPEND="${DEPEND}"
