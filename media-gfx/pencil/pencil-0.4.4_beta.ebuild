# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pencil/pencil-0.4.4_beta.ebuild,v 1.2 2011/08/28 10:49:57 hwoarang Exp $

EAPI=2
inherit qt4-r2

MY_P=${P/_beta/b}

DESCRIPTION="A Qt4 based animation and drawing program"
HOMEPAGE="http://www.pencil-animation.org/"
SRC_URI="mirror://sourceforge/pencil-planner/${MY_P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	>=media-libs/ming-0.4.3"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}-source

src_prepare() {
	sed -i s:SWFSprite:SWFMovieClip:g src/external/flash/flash.{cpp,h}
}

src_install() {
	# install target not yet provided
	#emake INSTALL_ROOT="${D}" install || die "emake install failed"
	newbin Pencil ${PN} || die "dobin failed"

	dodoc README TODO || die

	mv "${S}"/icons/icon.png "${S}"/icons/${PN}.png
	doicon "${S}"/icons/${PN}.png || die "doicon failed"
	make_desktop_entry ${PN} Pencil ${PN} Graphics
}
