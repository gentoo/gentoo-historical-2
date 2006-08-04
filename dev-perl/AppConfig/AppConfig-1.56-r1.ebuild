# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AppConfig/AppConfig-1.56-r1.ebuild,v 1.12 2006/08/04 22:21:11 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Perl5 module for reading configuration files and parsing command line arguments."
SRC_URI="mirror://cpan/authors/id/A/AB/ABW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~abw/${P}/"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 amd64 sparc alpha ppc"
IUSE=""

DEPEND="virtual/perl-Test-Simple
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/blockwhitespace.patch
}
