# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Elemental/XML-Elemental-1.03.ebuild,v 1.3 2006/07/05 13:18:09 ian Exp $

inherit perl-module

DESCRIPTION="an XML::Parser style and generic classes for simplistic and perlish handling of XML data. "
HOMEPAGE="http://search.cpan.org/~tima/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMA/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/XML-Parser"
RDEPEND="${DEPEND}"
