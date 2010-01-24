# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmpeg2/libmpeg2-0.5.1-r1.ebuild,v 1.3 2010/01/24 15:59:57 armin76 Exp $

EAPI=2
inherit eutils libtool

DESCRIPTION="library for decoding mpeg-2 and mpeg-1 video"
HOMEPAGE="http://libmpeg2.sourceforge.net/"
SRC_URI="http://libmpeg2.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="sdl X"

RDEPEND="sdl? ( media-libs/libsdl )
	X? ( x11-libs/libXv
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXt )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-arm-private-symbols.patch \
		"${FILESDIR}"/${P}-global-symbol-test.patch \
		"${FILESDIR}"/${P}-armv4l.patch
	elibtoolize
}

src_configure() {
	econf \
		--enable-shared \
		--disable-dependency-tracking \
		$(use_enable sdl) \
		$(use_with X x)
}

src_compile() {
	emake OPT_CFLAGS="${CFLAGS}" MPEG2DEC_CFLAGS="${CFLAGS}" \
		LIBMPEG2_CFLAGS="" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
