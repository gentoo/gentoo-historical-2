# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-XS-Loop-Poll/POE-XS-Loop-Poll-0.007.ebuild,v 1.2 2009/06/10 01:42:52 robbat2 Exp $

MODULE_AUTHOR="TONYC"

inherit perl-module

DESCRIPTION="an XS implementation of POE::Loop, using poll(2)."

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-perl/POE dev-perl/POE-Test-Loops"
RDEPEND="${DEPEND}"

SRC_TEST="do"
