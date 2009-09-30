# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-ParseExcel/Spreadsheet-ParseExcel-0.55.ebuild,v 1.1 2009/09/30 18:55:59 tove Exp $

EAPI=2

MODULE_AUTHOR=JMCNAMARA
inherit perl-module

DESCRIPTION="Get information from Excel file"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE="test cjk unicode"

RDEPEND="dev-perl/OLE-StorageLite
	dev-perl/IO-stringy
	dev-perl/Text-CSV_XS
	unicode? ( dev-perl/Unicode-Map )
	cjk? ( dev-perl/Jcode )"
DEPEND="virtual/perl-Module-Build
	test? ( dev-perl/Test-Pod
		dev-perl/Unicode-Map
		dev-perl/Spreadsheet-WriteExcel
		dev-perl/Jcode )
	${RDEPEND}"

SRC_TEST="do"
