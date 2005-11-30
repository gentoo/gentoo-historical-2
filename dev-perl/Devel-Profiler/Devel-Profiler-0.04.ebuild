# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Profiler/Devel-Profiler-0.04.ebuild,v 1.1.1.1 2005/11/30 09:52:44 chriswhite Exp $

inherit perl-module

DESCRIPTION="a Perl profiler compatible with dprofpp"
HOMEPAGE="http://search.cpan.org/~samtregar/${P}/"
SRC_URI="mirror://cpan/authors/id/S/SA/SAMTREGAR/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc ~amd64"
IUSE=""

SRC_TEST="do"
