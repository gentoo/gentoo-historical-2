# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xstroke/xstroke-0.6.ebuild,v 1.6 2006/01/21 18:56:37 nelchael Exp $

DESCRIPTION="Gesture/Handwriting recognition engine for X"
HOMEPAGE="http://www.xstroke.org/"
SRC_URI="http://www.xstroke.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha hppa ~mips ppc sparc x86"
IUSE=""

RDEPEND="|| ( (
		x11-libs/libXtst
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXft )
	virtual/x11 )"
DEPEND="${RDEPEND}
	media-libs/freetype
	media-libs/fontconfig
	|| ( (
		x11-proto/xextproto
		x11-proto/xproto )
	virtual/x11 )"

src_install() {
	make DESTDIR="${D}" BINDIR=/usr/bin install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
