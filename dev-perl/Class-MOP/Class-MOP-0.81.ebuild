# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MOP/Class-MOP-0.81.ebuild,v 1.1 2009/04/10 09:13:16 tove Exp $

EAPI=2

MODULE_AUTHOR=DROLSKY
inherit perl-module

DESCRIPTION="A Meta Object Protocol for Perl 5"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.18
	>=dev-perl/Sub-Name-0.04
	>=dev-perl/Sub-Identify-0.03
	>=dev-perl/MRO-Compat-0.05
	dev-perl/Devel-GlobalDestruction
	dev-perl/Task-Weaken"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	test? ( virtual/perl-Test-Simple
		dev-perl/Test-Exception )"

SRC_TEST=do
