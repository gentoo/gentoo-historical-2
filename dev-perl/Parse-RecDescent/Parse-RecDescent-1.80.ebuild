# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Parse-RecDescent/Parse-RecDescent-1.80.ebuild,v 1.1 2001/02/16 20:01:14 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Parse/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Parse/${P}.readme"

DEPEND=">=sys-devel/perl-5"

src_compile() {

    perl Makefile.PL 
    try make
    try make test

}

src_install () {

    try make PREFIX=${D}/usr install
    dodoc Changes README MANIFEST
    docinto html
    dodoc tutorial/*
}






