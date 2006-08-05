# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Table/HTML-Table-2.02.ebuild,v 1.4 2006/08/05 04:28:21 mcummings Exp $

inherit perl-module

DESCRIPTION="produces HTML tables"
HOMEPAGE="http://search.cpan.org/~ajpeacock/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AJ/AJPEACOCK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ppc sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
