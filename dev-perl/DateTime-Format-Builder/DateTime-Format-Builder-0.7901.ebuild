# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Builder/DateTime-Format-Builder-0.7901.ebuild,v 1.4 2009/05/30 09:07:52 tove Exp $

MODULE_AUTHOR="DROLSKY"

inherit perl-module

DESCRIPTION="Create DateTime parser classes and objects"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/DateTime
	dev-perl/Class-Factory-Util
	>=dev-perl/Params-Validate-0.91
	>=dev-perl/DateTime-Format-Strptime-1.0800"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? ( dev-perl/Test-Pod )"

SRC_TEST=do
