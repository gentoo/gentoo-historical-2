# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnet/gnet-1.1.5.ebuild,v 1.11 2004/06/24 23:11:08 agriffis Exp $

inherit eutils

DESCRIPTION="GNet network library."
SRC_URI="http://www.gnetlibrary.org/src/${P}.tar.gz"
HOMEPAGE="http://www.gnetlibrary.org/"

IUSE=""
SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc"

# yes, the >= is correct, this software can use both glib 1.2 and 2.0!
RDEPEND=">=dev-libs/glib-1.2.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		--sysconfdir=/etc \
		--localstatedir=/var/lib || die

	epatch ${FILESDIR}/${PN}-docdir-gentoo.diff

	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die

	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
}
