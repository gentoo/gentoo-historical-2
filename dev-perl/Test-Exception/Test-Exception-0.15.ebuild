# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Exception/Test-Exception-0.15.ebuild,v 1.2 2004/06/25 01:02:36 agriffis Exp $

inherit perl-module

DESCRIPTION="test functions for exception based code"
HOMEPAGE="http://search.cpan.org/~adie/${P}/"
SRC_URI="http://www.cpan.org/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
SRC_TEST="do"

DEPEND="dev-perl/Test-Simple
		dev-perl/Test-Builder-Tester
		dev-perl/Sub-Uplevel"
