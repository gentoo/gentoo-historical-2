# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Snowball-Norwegian/Snowball-Norwegian-1.0-r1.ebuild,v 1.1 2007/03/12 16:58:17 mcummings Exp $

inherit perl-module multilib

DESCRIPTION="Porters stemming algorithm for Norwegian"
HOMEPAGE="http://search.cpan.org/~asksh/"
SRC_URI="mirror://cpan/authors/id/A/AS/ASKSH/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"

src_install() {
	perl-module_src_install
	local version
	eval `perl '-V:version'`
	perl_version=${version} 
	local myarch
	eval `perl '-V:archname'`
	myarch=${archname} 

	if [ -f ${D}/usr/$(get_libdir)/perl5/vendor_perl/${perl_version}/Lingua/Stem/Snowball/stemmer.pl ]; then
		mv \
		${D}/usr/$(get_libdir)/perl5/vendor_perl/${perl_version}/Lingua/Stem/Snowball/stemmer.pl \
		${D}/usr/$(get_libdir)/perl5/vendor_perl/${perl_version}/Lingua/Stem/Snowball/no-stemmer.pl
	fi 
}

pkg_postinst() {
	perl-module_pkg_postinst
	elog "The stemmer.pl that ships with this distribution has been renamed to"
	elog "no-stemmer.pl to avoid collisions with other Lingua::Stem packages."
}
