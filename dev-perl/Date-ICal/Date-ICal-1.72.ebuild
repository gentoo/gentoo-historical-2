# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Date-ICal/Date-ICal-1.72.ebuild,v 1.5 2004/04/16 11:20:53 mcummings Exp $

inherit perl-module

MY_P=Date-ICal-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="ICal format date base module for Perl"
SRC_URI="http://www.cpan.org/modules/by-module/Date/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Date/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~ppc sparc ~alpha"

DEPEND="dev-perl/Date-Leapyear
	dev-perl/Test-Harness
	dev-perl/Test-Simple
	dev-perl/Time-Local
	dev-perl/Time-HiRes
	dev-perl/Storable"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
