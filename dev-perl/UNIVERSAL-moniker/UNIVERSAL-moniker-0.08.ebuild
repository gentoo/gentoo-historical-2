# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/UNIVERSAL-moniker/UNIVERSAL-moniker-0.08.ebuild,v 1.3 2005/01/13 02:59:14 gustavoz Exp $

inherit perl-module

DESCRIPTION="adds a moniker to every class or module"
HOMEPAGE="http://search.cpan.org/~kasei/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/K/KA/KASEI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE=""
SRC_TEST="do"

#Funny...no longer a dep, but needed for tests
DEPEND="dev-perl/Lingua-EN-Inflect"
