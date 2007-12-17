# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Graph/Graph-0.84.ebuild,v 1.3 2007/12/17 18:04:06 drac Exp $

inherit perl-module

DESCRIPTION="Data structure and ops for directed graphs"
SRC_URI="mirror://cpan/authors/id/J/JH/JHI/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Graph/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
SRC_TEST="do"

DEPEND="<dev-perl/Heap-0.80
	dev-lang/perl"
