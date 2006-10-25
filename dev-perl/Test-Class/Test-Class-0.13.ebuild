# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Class/Test-Class-0.13.ebuild,v 1.3 2006/10/25 15:08:15 gustavoz Exp $

inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit style."
HOMEPAGE="http://search.cpan.org/~adie/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=virtual/perl-Storable-2
	>=dev-perl/module-build-0.28
	>=virtual/perl-Test-Simple-0.62
	dev-perl/Test-Differences
	dev-perl/Test-Exception
	dev-perl/Test-SimpleUnit
	dev-perl/Pod-Coverage
	dev-lang/perl"
RDEPEND="${DEPEND}"
