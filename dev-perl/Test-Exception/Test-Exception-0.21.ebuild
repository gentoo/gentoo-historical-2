# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Exception/Test-Exception-0.21.ebuild,v 1.14 2007/01/19 16:46:43 mcummings Exp $

inherit perl-module

DESCRIPTION="test functions for exception based code"
HOMEPAGE="http://search.cpan.org/~adie/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=virtual/perl-Test-Simple-0.62
	>=dev-perl/module-build-0.28
	dev-perl/Sub-Uplevel
	dev-lang/perl"
