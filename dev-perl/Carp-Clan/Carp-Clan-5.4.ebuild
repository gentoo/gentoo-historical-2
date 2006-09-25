# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Carp-Clan/Carp-Clan-5.4.ebuild,v 1.1 2006/09/25 21:01:18 mcummings Exp $

inherit perl-module

DESCRIPTION="Report errors from perspective of caller of a clan of modules"
HOMEPAGE="http://search.cpan.org/~jjore/${P}/"
SRC_URI="mirror://cpan/authors/id/J/JJ/JJORE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

SRC_TEST="do"
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
