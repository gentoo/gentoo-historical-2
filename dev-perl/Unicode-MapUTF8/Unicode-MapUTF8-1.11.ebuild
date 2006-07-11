# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-MapUTF8/Unicode-MapUTF8-1.11.ebuild,v 1.13 2006/07/11 17:02:33 ian Exp $

inherit perl-module

DESCRIPTION="Conversions to and from arbitrary character sets and UTF8"
HOMEPAGE="http://www.cpan.org/modules/by-module/Unicode/${P}.readme"
SRC_URI="mirror://cpan/authors/id/S/SN/SNOWHARE/${P}.tar.gz"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ia64 ~ppc ~ppc64 sparc ~x86"
IUSE=""
DEPEND=">=dev-perl/module-build-0.28
	dev-perl/Unicode-Map
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String
	dev-perl/Jcode"
RDEPEND="${DEPEND}"
