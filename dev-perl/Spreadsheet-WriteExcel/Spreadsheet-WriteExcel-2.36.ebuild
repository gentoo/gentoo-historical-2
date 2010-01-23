# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-WriteExcel/Spreadsheet-WriteExcel-2.36.ebuild,v 1.1 2010/01/23 09:31:01 tove Exp $

EAPI=2

MODULE_AUTHOR=JMCNAMARA
inherit perl-module

DESCRIPTION="Write cross-platform Excel binary file."

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-File-Temp
	dev-perl/Parse-RecDescent
	>=dev-perl/OLE-StorageLite-0.19
	dev-perl/IO-stringy
	dev-lang/perl"
