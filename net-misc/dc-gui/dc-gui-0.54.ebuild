# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Jeffry Molanus <Gila@home.nl>
# Maintainer: Matthew Kennedy <mkennedy@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/dc-gui/dc-gui-0.54.ebuild,v 1.3 2002/04/25 06:26:48 mkennedy Exp $

S=${WORKDIR}/${P/-/_}
DESCRIPTION="GUI for DCTC"
SRC_URI="http://ac2i.tzo.com/dctc/${P/-/_}.tar.gz"
HOMEPAGE="http://ac2i.tzo.com/dctc"

DEPEND="virtual/glibc
	=dev-libs/glib-1.2*
	=gnome-base/gnome-1.4*
	=sys-libs/db-3.2*
	=x11-libs/gtk+-1.2*
	>=net-misc/dctc-0.79.1
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls && myconf="${myconf} --enable-nls" || myconf="${myconf} --disable-nls"

	./configure --prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		--with-gnome \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr install || die
	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
