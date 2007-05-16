# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Compress-Zlib/IO-Compress-Zlib-2.004.ebuild,v 1.7 2007/05/16 18:12:51 armin76 Exp $

inherit perl-module

DESCRIPTION="Read/Write compressed files"
HOMEPAGE="http://search.cpan.org/~pqms"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 m68k mips ppc ~ppc64 s390 sh sparc ~x86"
IUSE=""

DEPEND=">=dev-perl/IO-Compress-Base-2.004
	dev-perl/Compress-Raw-Zlib
	dev-lang/perl"

SRC_TEST="do"
