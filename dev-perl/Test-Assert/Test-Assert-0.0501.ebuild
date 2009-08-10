# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Assert/Test-Assert-0.0501.ebuild,v 1.2 2009/08/10 21:47:12 tove Exp $

EAPI=2
MODULE_AUTHOR="DEXTER"

inherit perl-module

DESCRIPTION="Assertion methods for those who like JUnit."

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/perl-parent
	>=dev-perl/Test-Unit-Lite-0.12
	dev-perl/constant-boolean
	>=dev-perl/Exception-Base-0.2201"
RDEPEND="${DEPEND}"
