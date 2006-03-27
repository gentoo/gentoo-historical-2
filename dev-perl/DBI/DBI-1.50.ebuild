# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.50.ebuild,v 1.5 2006/03/27 19:25:17 gustavoz Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBI Module"
HOMEPAGE="http://search.cpan.org/~timb/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMB/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=dev-perl/PlRPC-0.2"

mydoc="ToDo"
