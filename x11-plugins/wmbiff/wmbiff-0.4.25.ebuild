# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbiff/wmbiff-0.4.25.ebuild,v 1.8 2007/07/22 05:24:06 dberkholz Exp $

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes."
SRC_URI="mirror://sourceforge/wmbiff/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/wmbiff/"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	crypt? ( >=net-libs/gnutls-1.0.4
		>=dev-libs/libgcrypt-1.1.94 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc"
IUSE="crypt"

src_compile() {
	local myconf
	if ! use crypt; then
			myconf="--disable-crypto"
	fi
	econf ${myconf} || die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog  FAQ NEWS  README  README.licq  TODO  wmbiff/sample.wmbiffrc
}
