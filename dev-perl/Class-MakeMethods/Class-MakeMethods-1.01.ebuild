# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MakeMethods/Class-MakeMethods-1.01.ebuild,v 1.2 2005/04/19 15:55:31 luckyduck Exp $

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="Automated method creation module for Perl"
SRC_URI="mirror://cpan/authors/id/E/EV/EVO/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~evo/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86 ~amd64 ~ppc ~sparc ~alpha"
IUSE=""

SRC_TEST="do"

