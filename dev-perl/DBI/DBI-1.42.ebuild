# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.42.ebuild,v 1.3 2004/06/25 00:22:53 agriffis Exp $

inherit perl-module

DESCRIPTION="The Perl DBI Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/DBI/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/DBI/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~s390 ~ppc64"

DEPEND=">=dev-perl/PlRPC-0.2"

mydoc="ToDo"
