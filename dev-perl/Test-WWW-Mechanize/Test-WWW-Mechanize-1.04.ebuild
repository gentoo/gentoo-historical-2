# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-WWW-Mechanize/Test-WWW-Mechanize-1.04.ebuild,v 1.4 2006/07/05 10:55:02 ian Exp $

inherit perl-module

DESCRIPTION="Test::WWW::Mechanize is a subclass of WWW::Mechanize that
incorporates features for web application testing"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~petdance/${P}/"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~ppc ~x86"
SRC_TEST="do"

DEPEND=">=dev-perl/WWW-Mechanize-1.00
	>=dev-perl/Test-LongString-0.07"
RDEPEND="${DEPEND}"

src_compile() {
	echo "y" | perl-module_src_compile
}
