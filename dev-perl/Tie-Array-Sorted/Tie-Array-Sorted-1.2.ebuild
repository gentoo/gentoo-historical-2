# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Array-Sorted/Tie-Array-Sorted-1.2.ebuild,v 1.1 2004/10/06 23:20:23 mcummings Exp $

inherit perl-module

DESCRIPTION="An array which is kept sorted"
HOMEPAGE="http://search.cpan.org/~simon/${P}/"
SRC_URI="mirror://cpan/authors/id/S/SI/SIMON/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

SRC_TEST="do"
