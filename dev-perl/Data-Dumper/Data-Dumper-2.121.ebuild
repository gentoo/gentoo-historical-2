# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Dumper/Data-Dumper-2.121.ebuild,v 1.6 2004/12/24 15:02:16 nigoro Exp $
inherit perl-module

DESCRIPTION="Convert data structure into perl code"
SRC_URI="http://search.cpan.org/CPAN/authors/id/I/IL/ILYAM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~ilyam/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~mips ppc ~sparc ~ppc64"
IUSE=""

SRC_TEST="do"
