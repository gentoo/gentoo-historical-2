# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sub-Uplevel/Sub-Uplevel-0.09-r1.ebuild,v 1.2 2006/03/30 23:21:30 agriffis Exp $

inherit perl-module eutils

DESCRIPTION="apparently run a function in a higher stack frame"
HOMEPAGE="http://search.cpan.org/~mschwern/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/uplevel.patch
}
