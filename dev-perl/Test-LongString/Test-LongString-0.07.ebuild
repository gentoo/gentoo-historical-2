# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-LongString/Test-LongString-0.07.ebuild,v 1.3 2005/12/03 14:36:50 mcummings Exp $

inherit perl-module

DESCRIPTION="A library to test long strings."
HOMEPAGE="http://search.cpan.org/~rgarcia/${PN}/"
SRC_URI="mirror://cpan/authors/id/R/RG/RGARCIA/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~ppc ~x86 ~sparc"
IUSE=""
SRC_TEST="do"
