# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glpk/glpk-3.2.1.ebuild,v 1.2 2002/11/30 20:35:22 vapier Exp $

DESCRIPTION="GLPK - the GNU Linear Programming Kit"
HOMEPAGE="http://www.gnu.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

src_compile() {
	econf
	emake || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/include
	dodir /usr/lib
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING INSTALL README NEWS VERSION STATUS 
}
