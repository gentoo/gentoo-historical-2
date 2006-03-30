# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spreadsheet-WriteExcel/Spreadsheet-WriteExcel-2.16.ebuild,v 1.3 2006/03/30 23:19:37 agriffis Exp $

inherit perl-module

DESCRIPTION="Write cross-platform Excel binary file."
SRC_URI="mirror://cpan/authors/id/J/JM/JMCNAMARA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jmcnamara/Spreadsheet-WriteExcel-2.15/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

SRC_TEST="do"

DEPEND="virtual/perl-File-Temp
	dev-perl/Parse-RecDescent"
IUSE=""
