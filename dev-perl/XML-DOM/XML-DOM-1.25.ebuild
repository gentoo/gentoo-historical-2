# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DOM/XML-DOM-1.25.ebuild,v 1.6 2000/12/15 07:29:29 jerry Exp $

P=XML-DOM-1.25
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"
SRC_URI="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.readme"

DEPEND=">=sys-devel/perl-5
	>=dev-perl/XML-Parser-2.29"

src_compile() {

    cd ${S}
    perl Makefile.PL 
    try make 
    make test
}

src_install () {

    cd ${S}
    try make PREFIX=${D}/usr install
    dodoc Changes MANIFEST README rfc2396.txt

}









