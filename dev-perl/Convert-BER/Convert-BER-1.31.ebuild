# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-BER/Convert-BER-1.31.ebuild,v 1.1 2000/12/17 20:09:01 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="A Convert Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/Convert/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/Convert/${P}.readme"

DEPEND=">=sys-devel/perl-5"

src_compile() {
    cd ${S}
    perl Makefile.PL
    try make 
    try make test
}

src_install () {
    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc ChangeLog MANIFEST README
}



