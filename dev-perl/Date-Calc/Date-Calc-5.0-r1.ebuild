# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Date-Calc/Date-Calc-5.0-r1.ebuild,v 1.1 2002/05/04 02:45:39 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Date::Calc module for perl"
SRC_URI="http://www.cpan.org/authors/id/STBEY/${P}.tar.gz"

DEPEND="virtual/glibc >=sys-devel/perl-5"
LICENSE="Artistic | GPL-2"
SLOT="0"

src_compile() {
	OPTIMIZE="$CFLAGS" perl Makefile.PL /usr
	make || die
}

src_install () {
	eval `perl '-V:installarchlib'`
	mkdir -p ${D}/$installarchlib

	make \
		PREFIX=${D}/usr \
		INSTALLMAN3DIR=${D}/usr/share/man/man3 \
		INSTALLMAN1DIR=${D}/usr/share/man/man1 \
		install || die

	dodoc ChangeLog MANIFEST README ToDo
}
