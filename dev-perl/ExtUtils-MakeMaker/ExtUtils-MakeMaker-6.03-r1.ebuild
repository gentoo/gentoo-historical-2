# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-MakeMaker/ExtUtils-MakeMaker-6.03-r1.ebuild,v 1.1 2002/09/14 21:29:14 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="MakeMaker Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/ExtUtils/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/ExtUtils/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 sparc sparc64 ppc"

src_compile() {
	cd ${S}
	perl Makefile.PL ${myconf}

	perl-module_src_compile
}

src_install () {
	perl-module_src_install

}
