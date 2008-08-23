# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Array-Compare/Array-Compare-1.16.ebuild,v 1.1 2008/08/23 19:08:22 tove Exp $

MODULE_AUTHOR=DAVECROSS
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays."

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

SRC_TEST="do"

RDEPEND="dev-lang/perl"
DEPEND=">=dev-perl/module-build-0.28
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )
	${RDEPEND}"
