# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/obexftp/obexftp-0.9.2.ebuild,v 1.3 2002/07/25 19:18:34 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="File transfer over OBEX for Siemens mobile phones"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"
HOMEPAGE="http://triq.net/obexftp.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-libs/glib-1.2
	>=dev-libs/openobex-0.9.8"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog README* THANKS TODO
}
