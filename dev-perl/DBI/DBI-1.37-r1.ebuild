# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.37-r1.ebuild,v 1.1 2005/01/25 18:38:08 mcummings Exp $
inherit perl-module eutils

DESCRIPTION="The Perl DBI Module"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMB/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/DBI/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc ~alpha sparc hppa"
IUSE=""

DEPEND="${DEPEND}
	>=dev-perl/PlRPC-0.2"

mydoc="ToDo"

src_unpack(){
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/CAN-2005-0077.patch
}
