# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-GHTTP/HTTP-GHTTP-1.06.ebuild,v 1.6 2002/07/11 06:30:22 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="This module is a simple interface to the Gnome project's libghttp"
SRC_URI="http://cpan.valueclick.com/modules/by-module/HTTP/${A}"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/HTTP/${P}.readme"

DEPEND="virtual/glibc >=sys-devel/perl-5
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=gnome-base/libghttp-1.0.9-r1"
RDEPEND="virtual/glibc >=sys-devel/perl-5
	>=gnome-base/libghttp-1.0.9"

src_compile() {

    perl Makefile.PL
    try make
    try make test
}

src_install () {

    try make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install
    dodoc ChangeLog MANIFEST README* TODO

}



