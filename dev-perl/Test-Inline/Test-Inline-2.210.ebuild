# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Inline/Test-Inline-2.210.ebuild,v 1.1 2009/05/22 06:54:50 tove Exp $

EAPI=2

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Inline test suite support for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Spec-0.80
	virtual/perl-Memoize
	>=dev-perl/File-Slurp-9999.04
	>=dev-perl/File-Find-Rule-0.26
	dev-perl/File-chmod
	dev-perl/File-Remove
	>=dev-perl/Config-Tiny-2.00
	>=dev-perl/Params-Util-0.05
	>=dev-perl/Algorithm-Dependency-1.02
	>=dev-perl/File-Flat-1.00
	virtual/perl-Test-Simple
	>=dev-perl/Pod-Tests-0.18"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Script
		>=dev-perl/Class-Autouse-1.15
		>=dev-perl/Test-ClassAPI-1.02 )"

SRC_TEST="do"
