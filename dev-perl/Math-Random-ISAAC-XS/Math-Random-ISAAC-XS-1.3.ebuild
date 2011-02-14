# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Random-ISAAC-XS/Math-Random-ISAAC-XS-1.3.ebuild,v 1.1 2011/02/14 07:50:35 tove Exp $

EAPI=3

MODULE_AUTHOR=JAWNSY
MODULE_VERSION=1.003
inherit perl-module

DESCRIPTION="C implementation of the ISAAC PRNG algorithm"

LICENSE="|| ( public-domain Artistic Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Math-Random-ISAAC"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
		dev-perl/Test-NoWarnings
	)"

SRC_TEST="do"
