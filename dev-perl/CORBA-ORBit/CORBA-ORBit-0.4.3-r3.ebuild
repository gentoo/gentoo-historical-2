# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CORBA-ORBit/CORBA-ORBit-0.4.3-r3.ebuild,v 1.3 2002/07/23 22:29:48 seemant Exp $

inherit perl-module

S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="A Convert Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/CORBA/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/CORBA/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86"

DEPEND="${DEPEND}
	>=dev-perl/Error-0.13
	>=gnome-base/ORBit-0.5.6"

src_compile() {

	base_src_prep makemake

	cp Makefile Makefile.orig
	sed -e "s:-I/usr/include/orbit-1.0:-I/usr/include/orbit-1.0 -I/usr/include/libIDL-1.0:" \
		Makefile.orig > Makefile

	base_src_compile makemake
	base_src_compile test
}
