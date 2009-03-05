# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-ICal/Data-ICal-0.15.ebuild,v 1.1 2009/03/05 19:31:39 tove Exp $

MODULE_AUTHOR="ALEXMV"
inherit perl-module

DESCRIPTION="Generates iCalendar (RFC 2445) calendar files"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-lang/perl
	dev-perl/Class-Accessor
	dev-perl/class-returnvalue
	dev-perl/Text-vFile-asData"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Test-Warn
		dev-perl/Test-NoWarnings
		dev-perl/Test-LongString )"

SRC_TEST="do"
