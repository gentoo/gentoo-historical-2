# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glimpse/glimpse-4.17.4.ebuild,v 1.3 2004/02/17 00:00:04 agriffis Exp $

inherit eutils

DESCRIPTION="A index/query system to search a large set of files quickly"
SRC_URI="http://webglimpse.net/trial/${P}.tar.gz"
HOMEPAGE="http://webglimpse.net/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~ppc ~mips ~amd64 ~sparc ~alpha ~ia64"
IUSE="static"

src_compile() {
	econf || die

	if [ -z "`use static`" ]
	then
	    emake || die
	else
	    emake LDFLAGS=-static || die
	fi
}

src_install() {
	einstall || die
	dodir /usr/share/man/man1
	mv ${D}/usr/share/man/*.1 ${D}/usr/share/man/man1/
}
