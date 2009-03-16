# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DOM-XPath/XML-DOM-XPath-0.14.ebuild,v 1.2 2009/03/16 01:55:24 weaver Exp $

inherit perl-module

DESCRIPTION="Perl extension to add XPath support to XML::DOM, using XML::XPath engine"
HOMEPAGE="http://search.cpan.org/~mirod/${P}/XPath.pm"
SRC_URI="mirror://cpan/authors/id/M/MI/MIROD/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/XML-DOM
	dev-perl/XML-XPathEngine"
