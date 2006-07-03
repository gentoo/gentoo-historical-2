# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Boulder/Boulder-1.30.ebuild,v 1.5 2006/07/03 20:26:44 ian Exp $

inherit perl-module

DESCRIPTION="An API for hierarchical tag/value structures"
HOMEPAGE="http://search.cpan.org/~lds/${P}/"
SRC_URI="mirror://cpan/authors/id/L/LD/LDS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/XML-Parser"
RDEPEND="${DEPEND}"