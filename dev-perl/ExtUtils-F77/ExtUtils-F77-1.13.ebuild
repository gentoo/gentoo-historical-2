# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-F77/ExtUtils-F77-1.13.ebuild,v 1.3 2000/11/01 04:44:15 achim Exp $

P=ExtUtils-F77-1.13
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="F77 Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/ExtUtils/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/ExtUtils/${P}.readme"

DEPEND=">=sys-devel/perl-5"

src_compile() {

    cd ${S}
    perl Makefile.PL $PERLINSTALL
    try make
    try make test

}

src_install () {

    cd ${S}
    try make install
    prepman
    dodoc CHANGES README MANIFEST
}





