# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/qgifer/qgifer-0.2.1.ebuild,v 1.1 2013/07/14 11:57:27 tomwij Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="A video-based animated GIF creator."
HOMEPAGE="https://sourceforge.net/projects/qgifer/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug"

RDEPEND="media-libs/giflib:0
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/opencv:0[ffmpeg]
	virtual/ffmpeg"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8:0"

S="${WORKDIR}/${P}-source"

PATCHES=( "${FILESDIR}"/${P}-desktop.patch )

src_configure() {
	local mycmakeargs=""

	use debug && mycmakeargs+=" -DRELEASE_MODE=OFF"

	cmake-utils_src_configure
}
