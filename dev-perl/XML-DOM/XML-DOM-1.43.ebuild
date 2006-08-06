# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DOM/XML-DOM-1.43.ebuild,v 1.14 2006/08/06 01:17:22 mcummings Exp $

inherit perl-module

DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tjmather/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-perl/libwww-perl
	dev-perl/libxml-perl
	dev-perl/XML-Parser
	dev-perl/XML-RegExp
	dev-lang/perl"

RDEPEND="${DEPEND}"


