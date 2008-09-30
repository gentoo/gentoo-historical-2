# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-TimeZone/DateTime-TimeZone-0.80.ebuild,v 1.2 2008/09/30 12:22:16 tove Exp $

MODULE_AUTHOR=DROLSKY
inherit perl-module

DESCRIPTION="Time zone object base class and factory"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
SRC_TEST="do"

RDEPEND=">=dev-perl/Params-Validate-0.72
	>=dev-perl/Class-Singleton-1.03
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/module-build-0.28"
