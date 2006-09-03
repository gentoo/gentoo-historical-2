# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcut/xcut-0.2.ebuild,v 1.6 2006/09/03 14:18:58 jer Exp $

inherit eutils

IUSE=""
DESCRIPTION="Commandline tool to manipulate the X11 cut and paste buffers"
HOMEPAGE="http://xcut.sourceforge.net"
SRC_URI="mirror://sourceforge/xcut/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc x86"

RDEPEND="|| ( x11-libs/libX11 virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( (
		x11-proto/xproto
		x11-misc/imake )
	virtual/x11 )"

src_compile() {
	xmkmf || die
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	make DESTDIR=${D} install.man || die "make install.man failed"
	dodoc README || die "dodoc failed"
}
