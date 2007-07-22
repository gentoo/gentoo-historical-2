# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmnetselect/wmnetselect-0.8-r1.ebuild,v 1.13 2007/07/22 04:42:54 dberkholz Exp $

IUSE=""
DESCRIPTION="WindowMaker browser launcher docklet"
HOMEPAGE="http://freshmeat.net/projects/wmnetselect/"
SRC_URI="ftp://ftp11.freebsd.org/pub/FreeBSD/ports/distfiles/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-misc/imake"

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS}" wmnetselect || die
}

src_install () {
	dobin wmnetselect
	dodoc README ChangeLog TODO README.html
}
