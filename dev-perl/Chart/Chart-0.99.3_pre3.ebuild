# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Chart/Chart-0.99.3_pre3.ebuild,v 1.2 2001/05/03 16:38:57 achim Exp $

P=${PN}-0.99c-pre3
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl Chart Module"
SRC_URI="http://www.cpan.org/modules/by-module/Chart/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/Chart/${P}.readme"

DEPEND=">=dev-perl/GD-1.19
	>=sys-devel/perl-5"

src_compile() {

    perl Makefile.PL
    try make
    try make test

}

src_install () {

    try make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install
    dodoc TODO MANIFEST README

}



