# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-TimeZone/DateTime-TimeZone-0.27.ebuild,v 1.2 2004/06/08 12:21:55 dholm Exp $

inherit perl-module

DESCRIPTION="Time zone object base class and factory"
HOMEPAGE="http://search.cpan.org/~drolsky/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
style="builder"

DEPEND="dev-perl/module-build
		dev-perl/Params-Validate
		dev-perl/Class-Singleton"
