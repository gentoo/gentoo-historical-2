# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Algorithm::Annotate - represent a series of changes in annotate form"
SRC_URI="http://www.cpan.org/modules/by-authors/id/C/CL/CLKAO/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~ppc sparc x86"
SRC_TEST="do"

DEPEND="${DEPEND}
	>=dev-perl/Algorithm-Diff-1.15"
