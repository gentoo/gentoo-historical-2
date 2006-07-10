# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Array-Sorted/Tie-Array-Sorted-1.4.ebuild,v 1.5 2006/07/10 22:34:08 agriffis Exp $

inherit perl-module

DESCRIPTION="An array which is kept sorted"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"
