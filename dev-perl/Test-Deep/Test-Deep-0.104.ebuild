# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Deep/Test-Deep-0.104.ebuild,v 1.1 2009/03/06 12:48:36 tove Exp $

EAPI=2

MODULE_AUTHOR=FDALY
inherit perl-module

DESCRIPTION="Test::Deep - Extremely flexible deep comparison"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="
	test? ( dev-perl/Test-NoWarnings
		dev-perl/Test-Tester )"
RDEPEND=""

SRC_TEST="do"
