# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB-File/CDDB-File-1.03-r1.ebuild,v 1.4 2004/02/27 15:55:43 mcummings Exp $

inherit perl-module

S="${WORKDIR}/${P}"
DESCRIPTION="Parse a CDDB/freedb data file"
SRC_URI="http://search.cpan.org/CPAN/authors/id/T/TM/TMTM/${P}.tar.gz"
SLOT="0"
HOMEPAGE="http://search.cpan.org/author/TMTM/CDDB-File-${PV}/"
DEPEND="${DEPEND}
	dev-perl/Test-Simple"

LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc alpha"
