# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MakeMethods-Template/Class-MakeMethods-Template-1.004-r1.ebuild,v 1.3 2002/12/15 10:44:12 bjb Exp $

inherit perl-module

MY_P=Class-MakeMethods-Template-${PV}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"
DESCRIPTION="Extensible temlpates for Class::MakeMethods"
SRC_URI="http://www.cpan.org/modules/by-module/Class/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Class/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc alpha"
 
newdepend ">=Class-MakeMethods-1.003"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
