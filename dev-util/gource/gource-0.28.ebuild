# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gource/gource-0.28.ebuild,v 1.2 2011/02/25 20:54:44 signals Exp $

EAPI=2

inherit versionator

MY_P=${P/_p/-}
MY_P=${MY_P/_/-}
MY_DATE=${PV/*_p}

DESCRIPTION="A software version control visualization tool"
HOMEPAGE="http://code.google.com/p/gource/"
SRC_URI="http://gource.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2.10[opengl,X]
	>=media-libs/sdl-image-1.2[jpeg,png]
	dev-libs/libpcre:3
	>=media-libs/ftgl-2.1.3_rc5
	>=media-libs/libpng-1.2
	virtual/jpeg
	media-libs/mesa
	media-fonts/freefont-ttf
	>=media-libs/glew-1.5
	"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	media-libs/freetype:2
	"

case ${PV} in
	*_beta*)
		my_v=$(get_version_component_range 1-3)
		my_v=${my_v//_/-}
		S="${WORKDIR}/${PN}-${my_v}" ;;
	*)
		S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)" ;;
esac

src_configure() {
	econf --enable-ttf-font-dir=/usr/share/fonts/freefont-ttf/
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README ChangeLog THANKS || die "dodoc failed"
}
