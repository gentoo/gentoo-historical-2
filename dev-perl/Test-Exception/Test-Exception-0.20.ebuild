# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Exception/Test-Exception-0.20.ebuild,v 1.9 2005/12/06 12:54:00 mcummings Exp $

inherit perl-module

DESCRIPTION="test functions for exception based code"
HOMEPAGE="http://search.cpan.org/~adie/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="||( ( >=perl-core/Test-Simple-0.62 )
		( <perl-core/Test-Simple-0.62 dev-perl/Test-Builder-Tester ))
		dev-perl/Sub-Uplevel"
