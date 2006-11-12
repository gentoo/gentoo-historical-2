# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Compress-Base/IO-Compress-Base-2.001.ebuild,v 1.4 2006/11/12 03:17:59 vapier Exp $

inherit perl-module

DESCRIPTION="Base Class for IO::Compress modules"
HOMEPAGE="http://search.cpan.org/~pmqs"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~m68k ~mips ~ppc ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND="virtual/perl-Scalar-List-Utils
	dev-lang/perl"

SRC_TEST="do"
