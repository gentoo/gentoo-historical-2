# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.30.ebuild,v 1.14 2005/01/24 23:59:25 mcummings Exp $

inherit perl-module

DESCRIPTION="The Perl DBI Module"
SRC_URI="http://www.cpan.org/modules/by-module/DBI/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/DBI/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc alpha sparc"

DEPEND="${DEPEND}
	>=dev-perl/PlRPC-0.2"

mydoc="ToDo"
