# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-RSS-Parser/XML-RSS-Parser-4.0.ebuild,v 1.2 2006/01/13 22:37:50 mcummings Exp $

inherit perl-module

MY_PV=${PV/.0}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="A liberal object-oriented parser for RSS feeds"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/T/TI/TIMA/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Class-ErrorHandler
		>=dev-perl/Class-XPath-1.4
		>=dev-perl/XML-Elemental-2.0"
