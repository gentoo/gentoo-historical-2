# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/obexftp/obexftp-0.10.7-r1.ebuild,v 1.2 2005/12/17 15:40:28 metalgod Exp $

inherit eutils

DESCRIPTION="File transfer over OBEX for mobile phones"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"
HOMEPAGE="http://triq.net/obex"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86"
IUSE="bluetooth"

RDEPEND=">=dev-libs/openobex-1.0.0"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	bluetooth? ( >=net-wireless/bluez-utils-2.6 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.10.7-t610-jpg.patch || die
}

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
