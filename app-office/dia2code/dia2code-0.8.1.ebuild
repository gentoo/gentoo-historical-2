# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/dia2code/dia2code-0.8.1.ebuild,v 1.13 2004/06/28 14:15:53 vapier Exp $

inherit flag-o-matic

DESCRIPTION="Convert UML diagrams produced with Dia to various source code flavours."
HOMEPAGE="http://dia2code.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE=""

DEPEND="virtual/libc
	dev-libs/libxml2"
RDEPEND="${DEPEND}
	>=app-office/dia-0.90.0"

src_compile () {
	# libxml2 header fix
	append-flags -I/usr/include/libxml2/libxml
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README TODO
	doman dia2code.1
}
