# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gource/gource-0.24.ebuild,v 1.1 2010/02/09 14:19:15 flameeyes Exp $

EAPI=2

inherit versionator

MY_P=${P/_/-}

DESCRIPTION="A software version control visualization tool"
HOMEPAGE="http://code.google.com/p/gource/"
SRC_URI="http://gource.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2.10[opengl,X]
	>=media-libs/sdl-image-1.2[jpeg,png]
	dev-libs/libpcre:3
	>=media-libs/ftgl-2.1.3_rc5
	>=media-libs/libpng-1.2
	>=media-libs/jpeg-6b-r9
	media-libs/mesa
	media-fonts/freefont-ttf
	"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	media-libs/freetype:2
	"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

src_configure() {
	econf --enable-ttf-font-dir=/usr/share/fonts/freefont-ttf/
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README || die "dodoc failed"
}
