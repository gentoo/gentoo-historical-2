# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.51-r1.ebuild,v 1.4 2006/09/05 05:38:08 kumba Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBI Module"
HOMEPAGE="http://search.cpan.org/~timb/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMB/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/PlRPC-0.2
	>=perl-core/Sys-Syslog-0.17
	dev-lang/perl"

mydoc="ToDo"
