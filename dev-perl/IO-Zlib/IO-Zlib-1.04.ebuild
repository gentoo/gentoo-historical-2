# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Zlib/IO-Zlib-1.04.ebuild,v 1.3 2005/10/03 13:27:14 agriffis Exp $

inherit perl-module

DESCRIPTION="IO:: style interface to Compress::Zlib"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TO/TOMHUGHES/${P}.readme"
SRC_URI="mirror://cpan/authors/id/T/TO/TOMHUGHES/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Compress-Zlib"
