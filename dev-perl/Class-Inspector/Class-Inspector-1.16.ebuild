# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Inspector/Class-Inspector-1.16.ebuild,v 1.6 2006/09/28 19:35:00 gustavoz Exp $

inherit perl-module

DESCRIPTION="Provides information about Classes"
HOMEPAGE="http://search.cpan.org/~adamk/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc sparc ~x86"
IUSE=""

DEPEND="virtual/perl-Test-Simple
	dev-lang/perl"
RDEPEND="${DEPEND}"

SRC_TEST="do"
