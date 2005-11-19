# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime/DateTime-0.2901.ebuild,v 1.1 2005/11/19 08:19:01 mcummings Exp $

inherit perl-module

DESCRIPTION="A date and time object"
HOMEPAGE="http://search.cpan.org/~drolsky/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/Params-Validate-0.76
		>=perl-core/Time-Local-1.04
		>=dev-perl/DateTime-TimeZone-0.27
		>=dev-perl/DateTime-Locale-0.21"
