# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Sub/Tie-Sub-0.90.0.ebuild,v 1.1 2011/08/28 11:34:58 tove Exp $

EAPI=4

MODULE_AUTHOR=STEFFENW
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Tying a subroutine, function or method to a hash"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Params-Validate"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
		dev-perl/Test-NoWarnings
		dev-perl/Test-Exception
		>=dev-perl/Test-Pod-1.14
		>=dev-perl/Test-Pod-Coverage-1.04
		virtual/perl-Test-Simple
	)"

SRC_TEST="do"
