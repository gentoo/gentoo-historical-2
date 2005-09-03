# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Parser/HTML-Parser-3.45.ebuild,v 1.8 2005/09/03 19:29:43 corsair Exp $

inherit perl-module

DESCRIPTION="Parse <HEAD> section of HTML documents"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
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
