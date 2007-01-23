# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Class/Test-Class-0.22.ebuild,v 1.4 2007/01/23 00:30:55 kloeri Exp $

inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit style."
HOMEPAGE="http://search.cpan.org/~adie/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="${RDEPEND}
		dev-perl/module-build"
RDEPEND=">=virtual/perl-Storable-2
	>=dev-perl/module-build-0.28
	>=virtual/perl-Test-Simple-0.62
	dev-perl/Test-Differences
	dev-perl/Test-Exception
	dev-perl/Test-SimpleUnit
	dev-perl/Pod-Coverage
	>=virtual/perl-IO-1.23.01
	dev-lang/perl"
