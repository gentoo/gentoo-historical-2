# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/obexftp/obexftp-0.9.2.ebuild,v 1.6 2003/02/13 09:07:14 vapier Exp $

DESCRIPTION="File transfer over OBEX for Siemens mobile phones"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"
HOMEPAGE="http://triq.net/obexftp.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-libs/glib-1.2
	>=dev-libs/openobex-0.9.8"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README* THANKS TODO
}
