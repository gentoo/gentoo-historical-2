# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateManip/DateManip-5.42a-r1.ebuild,v 1.1 2003/09/10 19:10:04 max Exp $

inherit perl-module

DESCRIPTION="Perl date manipulation routines."
HOMEPAGE="http://www.perl.com/CPAN/authors/id/SBECK/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/Date/SBECK/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc ~alpha"

mydoc="HISTORY TODO"

src_unpack() {
	unpack ${A} && cd "${S}"
	epatch "${FILESDIR}/safe-taint-check.patch"
}
