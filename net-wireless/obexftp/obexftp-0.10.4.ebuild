# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/obexftp/obexftp-0.10.4.ebuild,v 1.3 2005/01/03 22:32:29 ticho Exp $

DESCRIPTION="File transfer over OBEX for mobile phones"
SRC_URI="mirror://sourceforge/openobex/${P}.tar.gz"
HOMEPAGE="http://triq.net/obex"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND=">=dev-libs/openobex-1.0.0"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_compile() {
	econf || die
	sed -i -e 's:apps doc contrib:apps contrib:' Makefile
	emake || die
}

src_install() {
	dohtml doc/*.html doc/*.css doc/*.png doc/*.xml doc/*.xsl
	doman doc/obexftp.1
	rm -rf doc
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog README* THANKS TODO
}
