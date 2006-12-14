# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/pekwm/pekwm-0.1.5.ebuild,v 1.3 2006/12/14 04:07:16 omp Exp $

DESCRIPTION="A small window mananger based on aewm++"
HOMEPAGE="http://www.pekwm.org/"
SRC_URI="http://pekwm.org/files/${PF}.tar.bz2
	mirror://gentoo/${PN}-themes.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug perl truetype xinerama"

DEPEND="media-libs/jpeg
	media-libs/libpng
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	perl? ( dev-libs/libpcre )
	truetype? ( virtual/xft )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable perl pcre) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		--enable-harbour \
		--enable-image-jpeg \
		--enable-image-png \
		--enable-image-xpm \
		--enable-menus \
		--enable-shape \
		--enable-xrandr || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog

	mv "${WORKDIR}/themes/"* "${D}/usr/share/${PN}/themes/"
}
