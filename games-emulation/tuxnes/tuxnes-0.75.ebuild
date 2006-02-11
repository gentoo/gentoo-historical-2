# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/tuxnes/tuxnes-0.75.ebuild,v 1.7 2006/02/11 04:21:22 joshuabaergen Exp $

inherit flag-o-matic eutils

DESCRIPTION="emulator for the 8-bit Nintendo Entertainment System"
HOMEPAGE="http://tuxnes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="X ggi"

RDEPEND=">=media-libs/netpbm-9.12
	X? ( || ( ( x11-libs/libSM
				x11-libs/libXpm )
			virtual/x11 ) )
	ggi? ( >=media-libs/libggi-2.0.1 )"
DEPEND="${RDEPEND}
	X? ( || ( x11-proto/xextproto virtual/x11 ) )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-configure.in.patch
	epatch "${FILESDIR}"/${P}-gcc34.patch
	export WANT_AUTOCONF=2.5
	aclocal && automake && autoconf || die "autoconf failed"
}

src_compile() {
	replace-flags "-O?" "-O"
	econf \
		--without-w \
		$(use_with ggi) \
		$(use_with X x) \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	insinto /usr/share/pixmaps
	doins tuxnes.xpm tuxnes2.xpm
	dodoc AUTHORS BUGS ChangeLog CHANGES NEWS README THANKS
}
