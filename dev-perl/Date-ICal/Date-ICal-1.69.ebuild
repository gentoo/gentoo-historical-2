# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Date-ICal/Date-ICal-1.69.ebuild,v 1.14 2004/06/25 00:20:59 agriffis Exp $

inherit perl-module

MY_P=Date-ICal-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="ICal format date base module for Perl"
SRC_URI="http://www.cpan.org/modules/by-module/Date/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Date/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="dev-perl/Date-Leapyear
	dev-perl/Time-HiRes
	dev-perl/Storable"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
