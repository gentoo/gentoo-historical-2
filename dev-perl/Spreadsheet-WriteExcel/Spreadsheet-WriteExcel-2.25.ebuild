# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-WriteExcel/Spreadsheet-WriteExcel-2.25.ebuild,v 1.1 2008/10/22 09:54:48 tove Exp $

MODULE_AUTHOR=JMCNAMARA
inherit perl-module

DESCRIPTION="Write cross-platform Excel binary file."

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-File-Temp
	dev-perl/Parse-RecDescent
	dev-perl/OLE-StorageLite
	dev-perl/IO-stringy
	dev-lang/perl"
