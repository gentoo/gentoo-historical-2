# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TimeDate/TimeDate-1.10.ebuild,v 1.1 2000/11/06 19:41:17 jerry Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="A Date/Time Parsing Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/Date/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/Date/${A}.readme"

DEPEND=">=sys-devel/perl-5"

src_compile() {
    cd ${S}
    perl Makefile.PL
    try make 
}

src_install () {
    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc ChangeLog MANIFEST README
}
