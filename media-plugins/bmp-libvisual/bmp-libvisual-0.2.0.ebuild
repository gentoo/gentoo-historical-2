# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/bmp-libvisual/bmp-libvisual-0.2.0.ebuild,v 1.3 2005/09/04 11:11:28 blubb Exp $

inherit eutils

MY_PN="libvisual-bmp"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Libvisual is an abstraction library that comes between applications and audio visualisation plugins."
HOMEPAGE="http://libvisual.sourceforge.net/"
SRC_URI="mirror://sourceforge/libvisual/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="media-sound/beep-media-player
	 >=media-plugins/libvisual-plugins-0.2
	 virtual/opengl
	 media-libs/libsdl"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.14"

src_install() {
	make DESTDIR="${D}" install || die

	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}
