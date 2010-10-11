# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MOP/Class-MOP-1.08.ebuild,v 1.2 2010/10/11 12:26:17 phajdan.jr Exp $

EAPI=3

#MODULE_AUTHOR=FLORA
MODULE_AUTHOR=DROLSKY
inherit perl-module

DESCRIPTION="A Meta Object Protocol for Perl 5"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"

RDEPEND="
	dev-perl/Data-OptList
	>=dev-perl/List-MoreUtils-0.12
	dev-perl/Package-DeprecationManager
	>=dev-perl/Package-Stash-0.03
	>=virtual/perl-Scalar-List-Utils-1.18
	>=dev-perl/Sub-Name-0.04
	>=dev-perl/Sub-Identify-0.03
	>=dev-perl/Try-Tiny-0.02
	>=dev-perl/MRO-Compat-0.05
	dev-perl/Devel-GlobalDestruction"
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.88
		>=dev-perl/Test-Exception-0.27
		dev-perl/Test-Output
		dev-perl/Test-Requires )"

SRC_TEST=do
