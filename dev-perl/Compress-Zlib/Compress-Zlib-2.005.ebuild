# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Zlib/Compress-Zlib-2.005.ebuild,v 1.1 2007/07/07 14:33:47 mcummings Exp $

inherit perl-module

DESCRIPTION="A Zlib perl module"
HOMEPAGE="http://search.cpan.org/~pmqs/"
SRC_URI="mirror://cpan/modules/by-module/Compress/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/zlib
	>=dev-perl/Compress-Raw-Zlib-2.005
	>=dev-perl/IO-Compress-Base-2.005
	>=dev-perl/IO-Compress-Zlib-2.005
	virtual/perl-Scalar-List-Utils
	dev-lang/perl"

SRC_TEST="do"

mydoc="TODO"
