# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-ParseExcel/Spreadsheet-ParseExcel-0.33.ebuild,v 1.1 2008/10/22 09:56:32 tove Exp $

MODULE_AUTHOR=SZABGAB
inherit perl-module

DESCRIPTION="Get information from Excel file"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE="test cjk unicode"
SRC_TEST="do"

RDEPEND="dev-perl/OLE-StorageLite
	dev-perl/IO-stringy
	unicode? ( dev-perl/Unicode-Map )
	cjk? ( dev-perl/Jcode )
	dev-lang/perl"
DEPEND="dev-perl/module-build
	test? ( dev-perl/Test-Pod
		dev-perl/Unicode-Map
		dev-perl/Spreadsheet-WriteExcel
		dev-perl/Jcode )
	${RDEPEND}"
