# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ORLite/ORLite-1.40.ebuild,v 1.2 2010/02/15 16:52:34 mr_bones_ Exp $

EAPI=2

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific ORM"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEPEND="
	>=virtual/perl-File-Path-2.04
	>=virtual/perl-File-Temp-0.17
	>=dev-perl/Params-Util-0.33
	>=dev-perl/DBI-1.607
	>=dev-perl/DBD-SQLite-1.27
	>=dev-perl/File-Remove-1.40
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		>=dev-perl/Test-Script-1.06
	)
"
RDEPEND="
	${COMMON_DEPEND}
"

SRC_TEST=do
