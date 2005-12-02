# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-ErrorHandler/Class-ErrorHandler-0.01.ebuild,v 1.5 2005/12/02 22:31:35 ferdy Exp $

inherit perl-module

DESCRIPTION="Automated accessor generation"
HOMEPAGE="http://search.cpan.org/~btrott/${P}/"
SRC_URI="mirror://cpan/authors/id/B/BT/BTROTT/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
KEYWORDS="~alpha ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/module-build"
