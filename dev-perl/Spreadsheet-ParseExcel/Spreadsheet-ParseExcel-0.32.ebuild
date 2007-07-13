# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-ParseExcel/Spreadsheet-ParseExcel-0.32.ebuild,v 1.4 2007/07/13 19:04:58 armin76 Exp $

inherit perl-module

DESCRIPTION="Get information from Excel file"
HOMEPAGE="http://search.cpan.org/~szabgab/"
SRC_URI="mirror://cpan/authors/id/S/SZ/SZABGAB/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ia64 sparc x86"
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
