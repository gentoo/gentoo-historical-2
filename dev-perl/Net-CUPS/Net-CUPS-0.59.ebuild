# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-CUPS/Net-CUPS-0.59.ebuild,v 1.2 2008/10/06 12:27:02 gentoofan23 Exp $

MODULE_AUTHOR=DHAGEMAN
inherit perl-module

DESCRIPTION="CUPS C API Interface"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~x86"
IUSE="test"
SRC_TEST="do"

RDEPEND=">=net-print/cups-1.1.21
	dev-lang/perl"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"
