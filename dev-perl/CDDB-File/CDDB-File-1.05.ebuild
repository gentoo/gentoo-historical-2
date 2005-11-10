# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB-File/CDDB-File-1.05.ebuild,v 1.1 2005/11/10 21:13:09 mcummings Exp $

inherit perl-module

DESCRIPTION="Parse a CDDB/freedb data file"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"
SLOT="0"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}/"
DEPEND="${DEPEND}
	perl-core/Test-Simple"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"
IUSE=""
SRC_TEST="do"
