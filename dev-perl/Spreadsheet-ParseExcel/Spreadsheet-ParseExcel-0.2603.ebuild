# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-ParseExcel/Spreadsheet-ParseExcel-0.2603.ebuild,v 1.3 2006/03/30 23:19:08 agriffis Exp $

inherit perl-module

DESCRIPTION="Get information from Excel file"
HOMEPAGE="http://search.cpan.org/~kwitknr/${P}/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWITKNR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/OLE-StorageLite"
