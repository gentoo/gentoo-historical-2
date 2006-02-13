# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Class/Test-Class-0.03.ebuild,v 1.12 2006/02/13 14:05:06 mcummings Exp $

inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit style."
HOMEPAGE="http://search.cpan.org/~adie/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=virtual/perl-Storable-2
		<virtual/perl-Test-Simple-0.48
		dev-perl/Test-Builder-Tester
		dev-perl/Test-Differences
		dev-perl/Test-Exception
		dev-perl/Test-SimpleUnit
		dev-perl/Pod-Coverage"
