# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-XPath/XML-XPath-1.13.ebuild,v 1.9 2005/01/04 14:33:53 mcummings Exp $

inherit perl-module

DESCRIPTION="A XPath Perl Module"
SRC_URI="mirror://cpan/authors/id/M/MS/MSERGEANT/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~msergeant/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~ppc sparc alpha ~mips"
IUSE=""

DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.30"
