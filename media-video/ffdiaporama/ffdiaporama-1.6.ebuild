# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffdiaporama/ffdiaporama-1.6.ebuild,v 1.2 2013/07/05 21:56:06 hasufell Exp $

EAPI=5

inherit eutils fdo-mime gnome2-utils qt4-r2

DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="http://ffdiaporama.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/${PN}/Archives/${PN}_${PV}.tar.gz
    texturemate? ( http://download.tuxfamily.org/${PN}/Archives/ffDiaporama-texturemate_1.0.tar.gz )"

LICENSE="GPL-2
	texturemate? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="texturemate"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	media-gfx/exiv2
	media-libs/libsdl[audio]
	media-libs/qimageblitz
	media-libs/taglib
	>=media-video/ffmpeg-1.0[encode]"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )

src_unpack() {
	# S=${WORKDIR} would result in unremoved files in
	# ${WORKDIR}/../build
	mkdir ${P} || die
	cd ${P} || die
	unpack ${A}
}

src_install() {
	qt4-r2_src_install
	doicon -s 32 ffdiaporama.png
	if use texturemate; then
		cd ffDiaporama-texturemate || die
		./install.sh "${D}"/usr
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
