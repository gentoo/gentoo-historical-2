# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.51-r1.ebuild,v 1.7 2007/01/02 22:12:27 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="The Perl DBI Module"
HOMEPAGE="http://search.cpan.org/~timb/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMB/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc ~ppc64 sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/PlRPC-0.2
	>=virtual/perl-Sys-Syslog-0.17
	dev-lang/perl"

mydoc="ToDo"
