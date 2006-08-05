# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-TimeZone/DateTime-TimeZone-0.45.ebuild,v 1.6 2006/08/05 02:49:00 mcummings Exp $

inherit perl-module

DESCRIPTION="Time zone object base class and factory"
HOMEPAGE="http://search.cpan.org/~drolsky/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc sparc ~x86"
IUSE="test"
SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
	>=dev-perl/Params-Validate-0.72
		>=dev-perl/Class-Singleton-1.03
	dev-lang/perl"
RDEPEND="${DEPEND}"


