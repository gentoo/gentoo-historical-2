# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Calendar-Simple/Calendar-Simple-1.13.ebuild,v 1.2 2006/06/21 17:19:28 nixnut Exp $

inherit perl-module

DESCRIPTION="Perl extension to create simple calendars"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/D/DA/DAVECROSS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="test"

SRC_TEST="do"

DEPEND="dev-perl/module-build
		test? ( dev-perl/Test-Pod
				dev-perl/Test-Pod-Coverage )"
