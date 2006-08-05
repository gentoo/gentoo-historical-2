# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Finance-Quote/Finance-Quote-1.08-r1.ebuild,v 1.11 2006/08/05 04:02:45 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="The Perl Finance-Quote Module"
HOMEPAGE="http://search.cpan.org/~pjf/${P}/"
SRC_URI="mirror://cpan/authors/id/P/PJ/PJF/${P}.tar.gz"

IUSE=""

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"

SRC_TEST="do"

DEPEND="dev-perl/libwww-perl
	dev-perl/HTML-TableExtract
	dev-lang/perl"
RDEPEND="${DEPEND}"

mydoc="TODO"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-tase.patch
}


