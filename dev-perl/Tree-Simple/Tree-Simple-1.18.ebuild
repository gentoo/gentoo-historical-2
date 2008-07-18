# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tree-Simple/Tree-Simple-1.18.ebuild,v 1.1 2008/07/18 12:31:44 tove Exp $

MODULE_AUTHOR=STEVAN
inherit perl-module

DESCRIPTION="A simple tree object"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/module-build-0.28
	test? ( >=virtual/perl-Test-Simple-0.47
		>=dev-perl/Test-Exception-0.15 )"

SRC_TEST="do"
