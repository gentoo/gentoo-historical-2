# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xvkbd/xvkbd-2.5a.ebuild,v 1.4 2004/06/24 22:46:24 agriffis Exp $

DESCRIPTION="virtual keyboard for X window system"
HOMEPAGE="http://member.nifty.ne.jp/tsato/xvkbd/"
SRC_URI="http://member.nifty.ne.jp/tsato/xvkbd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/x11
	x11-libs/Xaw3d"

src_compile() {
	xmkmf -a || die
	emake CDEBUGFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc README
	newman ${PN}.man ${PN}.1
}
