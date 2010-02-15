# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-POM/Pod-POM-0.25.ebuild,v 1.1 2010/02/15 12:58:44 tove Exp $

EAPI=2

MODULE_AUTHOR=ANDREWF
inherit perl-module

DESCRIPTION="POD Object Model"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? ( dev-perl/Test-Differences
		>=dev-perl/yaml-0.67
		dev-perl/File-Slurp )"

SRC_TEST=do
