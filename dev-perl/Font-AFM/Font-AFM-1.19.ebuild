# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Font-AFM/Font-AFM-1.19.ebuild,v 1.9 2006/07/10 15:47:19 agriffis Exp $

# this is a dependency for RT

inherit perl-module

DESCRIPTION="Parse Adobe Font Metric files"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/G/GA/GAAS/${P}.readme"

SRC_TEST="do"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ia64 ~ppc sparc x86"
IUSE=""
