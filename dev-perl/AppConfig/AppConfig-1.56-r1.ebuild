# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AppConfig/AppConfig-1.56-r1.ebuild,v 1.8 2005/04/24 13:47:48 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Perl5 module for reading configuration files and parsing command line arguments."
SRC_URI="mirror://cpan/authors/id/A/AB/ABW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~abw/${P}/"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 amd64 sparc alpha ppc"
IUSE=""

DEPEND="dev-perl/Test-Simple"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/blockwhitespace.patch
}
