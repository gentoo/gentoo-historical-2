# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Twig/XML-Twig-3.15-r1.ebuild,v 1.9 2005/07/09 23:13:26 swegener Exp $

inherit perl-module

DESCRIPTION="This module provides a way to process XML documents. It is build on top of XML::Parser"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${P}.readme"
SRC_URI="mirror://cpan/authors/id/M/MI/MIROD/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ~ppc sparc amd64 alpha"
IUSE="nls"

SRC_TEST="do"

# Twig ONLY works with expat 1.95.5
DEPEND=">=dev-perl/XML-Parser-2.31
	dev-perl/Scalar-List-Utils
	>=dev-libs/expat-1.95.5
	dev-perl/Tie-IxHash
	dev-perl/XML-SAX-Writer
	dev-perl/XML-Handler-YAWriter
	dev-perl/XML-XPath
	nls? ( >=dev-perl/Text-Iconv-1.2-r1 )"

src_compile() {
	echo "" | perl-module_src_compile
}
