# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xterm/xterm-179.ebuild,v 1.6 2004/04/07 22:57:00 seemant Exp $

IUSE="truetype"

S=${WORKDIR}/${P}
DESCRIPTION="Terminal Emulator for X Windows"
HOMEPAGE="http://dickey.his.com/xterm/"
SRC_URI="ftp://invisible-island.net/${PN}/${P}.tgz"

SLOT="0"
LICENSE="X11"
KEYWORDS="~x86 ~ppc sparc ~alpha ~hppa ~mips ~amd64 ~ia64"

DEPEND="virtual/x11
	sys-apps/utempter"


src_compile() {

	local myconf

	econf \
		--libdir=/etc \
		--enable-wide-chars \
		--with-utempter \
		--enable-256-color \
		`use_enable truetype freetype` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README* INSTALL*
}
