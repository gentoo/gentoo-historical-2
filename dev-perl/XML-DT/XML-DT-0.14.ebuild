# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DT/XML-DT-0.14.ebuild,v 1.5 2000/11/04 12:54:30 achim Exp $

P=XML-DT-0.14
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="A perl XML down translate module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/XML/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/XML/${P}.readme"

DEPEND=">=sys-devel/perl-5
	>=dev-perl/XML-Parser-2.29"

src_unpack() {
    unpack $A
    cd ${S}
    cp DT.pm DT.pm.orig
    sed -e "s:(C<-type)):(C<-type>):" DT.pm.orig > DT.pm
}
src_compile() {

    cd ${S}
    perl Makefile.PL
    try make
    try make test

}

src_install () {

    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc Changes README MANIFEST
    docinto html
    dodoc DT.html
}






