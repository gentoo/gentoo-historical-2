# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Daemon/Net-Daemon-0.34.ebuild,v 1.2 2001/01/31 20:49:06 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl Net-Daemon Module"
SRC_URI="http://www.cpan.org/modules/by-module/Net/${A}"
HOMEPAGE="http://www.cpan.org/modules/by-module/Net/${P}.readme"

DEPEND=">=sys-devel/perl-5"

src_compile() {
    cd ${S}
    perl Makefile.PL
    try make
#    try make test
}

src_install () {
    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc ChangeLog MANIFEST README
}



