# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gource/gource-0.24_p20100126.ebuild,v 1.1 2010/01/31 15:39:36 flameeyes Exp $

EAPI=2

inherit autotools

GITHUB_USER="acaudwell"
TREE_HASH="820a2a53df407a97ede32c6b814b869aea58def0"

DESCRIPTION="A software version control visualization tool"
HOMEPAGE="http://code.google.com/p/gource/"
SRC_URI="http://github.com/${GITHUB_USER}/${PN}/tarball/${TREE_HASH} -> ${PN}-git-${PV}.tgz"

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

S="${WORKDIR}/${GITHUB_USER}-Gource-${TREE_HASH:0:7}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --enable-ttf-font-dir=/usr/share/fonts/freefont-ttf/
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README || die "dodoc failed"
}
