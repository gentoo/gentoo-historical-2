# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBI/DBI-1.14.ebuild,v 1.4 2001/05/30 18:24:34 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl DBI Module"
SRC_URI="http://www.cpan.org/modules/by-module/DBI/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/DBI/${P}.readme"

DEPEND="virtual/glibc
        >=sys-devel/perl-5
	>=dev-perl/PlRPC-0.2"

src_compile() {
    perl Makefile.PL
    try make
    #try make test
}

src_install () {
    try make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 \
	INSTALLMAN1DIR=${D}/usr/share/man/man1 install
    dodoc ChangeLog MANIFEST README ToDo
}



