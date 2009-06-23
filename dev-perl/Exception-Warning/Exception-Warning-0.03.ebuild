# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Exception-Warning/Exception-Warning-0.03.ebuild,v 1.1 2009/06/23 07:40:21 robbat2 Exp $

EAPI=2
MODULE_AUTHOR="DEXTER"

inherit perl-module

DESCRIPTION="Convert simple warn into real exception object"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-perl/Test-Unit-Lite-0.12
	>=dev-perl/Exception-Base-0.2201"
RDEPEND="${DEPEND}"
