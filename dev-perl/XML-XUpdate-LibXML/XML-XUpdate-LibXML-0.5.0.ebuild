# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-XUpdate-LibXML/XML-XUpdate-LibXML-0.5.0.ebuild,v 1.1 2004/06/11 14:00:36 mcummings Exp $

IUSE=""
inherit perl-module
DESCRIPTION="Process XUpdate commands over an XML document."
SRC_URI="http://search.cpan.org/CPAN/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http:/search.cpan.org/~pajas/${P}/"
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

SRC_TEST="do"

DEPEND=">=dev-perl/XML-LibXML-1.54
		dev-perl/XML-LibXML-XPathContext
		dev-perl/XML-LibXML-Iterator"
