# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xterm/xterm-179.ebuild,v 1.2 2003/05/31 07:37:13 seemant Exp $

IUSE="truetype"

S=${WORKDIR}/${P}
DESCRIPTION="Terminal Emulator for X Windows"
HOMEPAGE="http://dickey.his.com/xterm/"
SRC_URI="ftp://invisible-island.net/${PN}/${P}.tgz"

SLOT="0"
LICENSE="X11"
KEYWORDS="~x86"

DEPEND="virtual/x11
	sys-apps/utempter"


src_compile() {

	local myconf

	use truetype \
		&& myconf="${myconf} --enable-freetype" \
		|| myconf="${myconf} --disable-freetype"

	econf \
		--libdir=/etc \
		--enable-wide-chars \
		--with-utempter \
		--enable-256-color || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README* INSTALL*
}
