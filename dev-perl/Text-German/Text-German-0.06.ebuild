# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-German/Text-German-0.06.ebuild,v 1.3 2006/06/12 16:50:58 mcummings Exp $

inherit perl-module

DESCRIPTION="German grundform reduction"
HOMEPAGE="http://search.cpan.org/~ulpfr/${P}/"
SRC_URI="mirror://cpan/authors/id/U/UL/ULPFR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"
