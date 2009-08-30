# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Array-Compare/Array-Compare-2.01.ebuild,v 1.1 2009/08/30 13:01:55 tove Exp $

EAPI=2

MODULE_AUTHOR=DAVECROSS
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

RDEPEND="dev-perl/Moose"
DEPEND=">=virtual/perl-Module-Build-0.28
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )
	${RDEPEND}"
