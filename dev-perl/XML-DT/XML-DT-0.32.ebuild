# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DT/XML-DT-0.32.ebuild,v 1.1 2004/09/22 14:37:40 mcummings Exp $

inherit perl-module

DESCRIPTION="A perl XML down translate module"
SRC_URI="http://search.cpan.org/CPAN/authors/id/J/JJ/JJOAO/${P}.tar.gz"
HOMEPAGE="http://search/cpan/org/~jjoao/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~ppc"
IUSE=""

SRC_TEST="do"

DEPEND="${DEPEND}
	dev-perl/libwww-perl
	dev-perl/XML-LibXML
	dev-perl/Test-Simple
	dev-perl/Test-Pod
	dev-perl/Test-Pod-Coverage
	>=dev-perl/XML-Parser-2.31"

src_compile() {
	echo "" | perl-module_src_compile
}
