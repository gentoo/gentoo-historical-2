# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Date-Leapyear/Date-Leapyear-1.7.ebuild,v 1.8 2002/12/09 04:21:06 manson Exp $

inherit perl-module

MY_P=Date-Leapyear-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple Perl module that tracks Gregorian leap years"
SRC_URI="http://www.cpan.org/modules/by-module/Date/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Date/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc  alpha"

newdepend "dev-perl/Test-Simple"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
