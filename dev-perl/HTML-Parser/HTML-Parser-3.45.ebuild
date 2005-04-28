# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Parser/HTML-Parser-3.45.ebuild,v 1.2 2005/04/28 13:05:58 mcummings Exp $

inherit perl-module

DESCRIPTION="Parse <HEAD> section of HTML documents"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~ia64 ~ppc64 ~mips"
IUSE="unicode"
DEPEND=">=dev-perl/HTML-Tagset-3.03"
mydoc="ANNOUNCEMENT TODO"

src_compile() {
	use unicode && answer='y' || answer='n'
	if [ "${MMSIXELEVEN}" ]; then
		echo "${answer}" | perl Makefile.PL ${myconf} \
		PREFIX=/usr INSTALLDIRS=vendor DESTDIR=${D}
	else
		echo "${answer}" | perl Makefile.PL ${myconf} \
		PREFIX=${D}/usr INSTALLDIRS=vendor
	fi
	perl-module_src_test
}
