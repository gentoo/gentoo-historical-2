# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Zlib/Compress-Zlib-1.10.ebuild,v 1.2 2001/03/12 10:52:49 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A Zlib perl module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Compress/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Compress/${P}.readme"

DEPEND=">=sys-devel/perl-5
	>=sys-libs/zlib-1.1.3"

src_compile() {

    perl Makefile.PL
    try make
    try make test
}

src_install () {

    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc ChangeLog MANIFEST README* TODO

}



