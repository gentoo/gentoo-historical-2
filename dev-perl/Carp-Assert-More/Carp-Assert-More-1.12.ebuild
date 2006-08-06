# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Carp-Assert-More/Carp-Assert-More-1.12.ebuild,v 1.11 2006/08/06 18:58:44 mcummings Exp $

inherit perl-module

DESCRIPTION="convenience wrappers around Carp::Assert"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-Scalar-List-Utils
	dev-perl/Carp-Assert
	dev-perl/Test-Exception
	dev-lang/perl"
RDEPEND="${DEPEND}"
