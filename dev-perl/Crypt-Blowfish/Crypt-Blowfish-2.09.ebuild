# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-Blowfish/Crypt-Blowfish-2.09.ebuild,v 1.1 2002/01/27 03:27:03 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Crypt::Blowfish module for perl"
SRC_URI="http://www.cpan.org/authors/id/D/DP/DPARIS/${P}.tar.gz"
DEPEND="virtual/glibc >=sys-devel/perl-5"

src_compile() {

	OPTIMIZE="$CFLAGS" perl Makefile.PL
	make || die
}

src_install () {

	eval `perl '-V:installarchlib'`
	mkdir -p ${D}/$installarchlib

	perl Makefile.PL
	make \
		PREFIX=${D}/usr \
		INSTALLMAN3DIR=${D}/usr/share/man/man3 \
		INSTALLMAN1DIR=${D}/usr/share/man/man1 \
		install || die

	dodoc ChangeLog MANIFEST README ToDo
}
