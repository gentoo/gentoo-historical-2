# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Compress-Base/IO-Compress-Base-2.001.ebuild,v 1.3 2006/11/10 13:53:51 nixnut Exp $

inherit perl-module


DESCRIPTION="Base Class for IO::Compress modules"
HOMEPAGE="http://search.cpan.org/~pmqs"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~mips ~ppc ~sparc x86"
SRC_TEST="do"

DEPEND="virtual/perl-Scalar-List-Utils
		dev-lang/perl"
