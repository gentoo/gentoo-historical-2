# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Bugzilla/WWW-Bugzilla-0.2.ebuild,v 1.4 2004/06/25 01:09:22 agriffis Exp $

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="automate interaction with bugzilla"
SRC_URI="http://search.cpan.org/CPAN/authors/id/M/MC/MCVELLA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mcvella/${P}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64"

DEPEND="dev-perl/WWW-Mechanize
	dev-perl/Class-MethodMaker"

