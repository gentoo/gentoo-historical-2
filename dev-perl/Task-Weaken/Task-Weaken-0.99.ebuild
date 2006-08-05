# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Task-Weaken/Task-Weaken-0.99.ebuild,v 1.2 2006/08/05 23:09:36 mcummings Exp $

inherit perl-module

DESCRIPTION="Ensure that a platform has weaken support "
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${P}.tar.gz"


IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~sparc ~x86"

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
