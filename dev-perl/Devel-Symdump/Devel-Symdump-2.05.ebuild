# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Symdump/Devel-Symdump-2.05.ebuild,v 1.2 2006/03/13 21:20:22 gustavoz Exp $

inherit perl-module

DESCRIPTION="dump symbol names or the symbol table"
HOMEPAGE="http://search.cpan.org/~andk/${P}"
SRC_URI="mirror://cpan/authors/id/A/AN/ANDK/${P}.tar.gz"

SRC_TEST="do"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
