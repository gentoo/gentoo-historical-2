# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Twig/XML-Twig-3.22.ebuild,v 1.9 2006/07/05 13:57:26 ian Exp $

inherit perl-module

DESCRIPTION="This module provides a way to process XML documents. It is build on top of XML::Parser"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/XML-Twig-3.22.readme"
SRC_URI="mirror://cpan/authors/id/M/MI/MIROD/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc x86"
IUSE="nls"

SRC_TEST="do"

# Twig ONLY works with expat 1.95.5
DEPEND=">=dev-perl/XML-Parser-2.31
	perl-core/Scalar-List-Utils
	>=dev-libs/expat-1.95.5
	dev-perl/Tie-IxHash
	dev-perl/XML-SAX-Writer
	dev-perl/XML-Handler-YAWriter
	dev-perl/XML-XPath
	nls? ( >=dev-perl/Text-Iconv-1.2-r1 )"
RDEPEND="${DEPEND}"

src_compile() {
	echo "" | perl-module_src_compile
}