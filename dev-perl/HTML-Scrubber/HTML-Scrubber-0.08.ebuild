# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Scrubber/HTML-Scrubber-0.08.ebuild,v 1.8 2005/05/25 15:08:44 mcummings Exp $

# this is an RT dependency

inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"
SRC_URI="mirror://cpan/authors/id/P/PO/PODMASTER/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/P/PO/PODMASTER/${P}.readme"

SRC_TEST="do"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 ~ppc sparc"

DEPEND="perl-core/Test-Simple
	dev-perl/HTML-Parser"
IUSE=""
