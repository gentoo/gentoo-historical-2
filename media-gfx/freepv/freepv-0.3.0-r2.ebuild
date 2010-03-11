# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/freepv/freepv-0.3.0-r2.ebuild,v 1.1 2010/03/11 15:30:44 voyageur Exp $

EAPI=2

inherit cmake-utils

DESCRIPTION="Panorama viewer (Quicktime, PangeaVR, GLPanoView formats)"
HOMEPAGE="http://freepv.sourceforge.net/"
SRC_URI="mirror://sourceforge/freepv/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	media-libs/jpeg
	media-libs/libpng
	virtual/glut
	sys-libs/zlib
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-noplugin.patch
	sed -i \
		-e 's:jpeg_mem_src:freepv_jpeg_mem_src:g' \
		src/libfreepv/JpegReader.cpp || die
}
