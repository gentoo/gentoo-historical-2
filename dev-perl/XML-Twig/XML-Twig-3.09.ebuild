# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Twig/XML-Twig-3.09.ebuild,v 1.10 2004/05/25 14:34:26 mcummings Exp $

inherit perl-module

MY_P=XML-Twig-${PV}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"

DESCRIPTION="This module provides a way to process XML documents. It is build on top of XML::Parser"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${MY_P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/XML/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc alpha"
IUSE="nls"

# Twig ONLY works with expat 1.95.5
DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.31
	dev-perl/Scalar-List-Utils
	dev-perl/XML-XPath
	>=dev-libs/expat-1.95.5
	nls? ( >=dev-perl/Text-Iconv-1.2-r1 )"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
