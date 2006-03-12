# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/blassic/blassic-0.10.0.ebuild,v 1.8 2006/03/12 22:40:38 mr_bones_ Exp $

DESCRIPTION="classic Basic interpreter"
HOMEPAGE="http://blassic.org"
SRC_URI="http://blassic.org/bin/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="hppa ppc ~ppc-macos x86"
SLOT="0"
IUSE="svga X"

RDEPEND="sys-libs/ncurses
	X? (
		|| (
			( x11-libs/libICE x11-libs/libX11 x11-libs/libSM )
			virtual/x11
		)
	)
	svga? ( media-libs/svgalib )"
DEPEND="${RDEPEND}
	X? (
		|| (
			x11-proto/xproto
			virtual/x11 )
	)"

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_with X x) \
		$(use_enable svga svgalib) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README THANKS TODO
}
