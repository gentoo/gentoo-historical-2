# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-TimeZone/DateTime-TimeZone-0.59.ebuild,v 1.1 2007/01/19 21:39:27 mcummings Exp $

inherit perl-module

DESCRIPTION="Time zone object base class and factory"
HOMEPAGE="http://search.cpan.org/~drolsky/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
		$RDEPEND"
RDEPEND=">=dev-perl/Params-Validate-0.72
	>=dev-perl/Class-Singleton-1.03
	dev-lang/perl"
