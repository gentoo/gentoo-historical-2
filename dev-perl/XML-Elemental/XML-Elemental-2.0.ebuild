# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Elemental/XML-Elemental-2.0.ebuild,v 1.7 2006/07/10 22:59:20 agriffis Exp $

inherit perl-module

DESCRIPTION="an XML::Parser style and generic classes for simplistic and perlish handling of XML data. "
HOMEPAGE="http://search.cpan.org/~tima/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMA/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~hppa ia64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/XML-Parser
		dev-perl/XML-SAX
		dev-perl/Class-Accessor"
RDEPEND="${DEPEND}"