# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/simgear/simgear-2.8.0.ebuild,v 1.2 2012/08/31 21:25:05 reavertm Exp $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
SRC_URI="http://mirrors.ibiblio.org/pub/mirrors/simgear/ftp/Source/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="debug jpeg subversion test"

COMMON_DEPEND="
	>=dev-games/openscenegraph-3.0.1
	media-libs/freealut
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	jpeg? ( virtual/jpeg )
	subversion? (
		dev-libs/apr
		dev-vcs/subversion
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.37
"
RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_RTI=OFF
		-DSIMGEAR_HEADLESS=OFF
		-DSIMGEAR_SHARED=ON
		$(cmake-utils_use jpeg JPEG_FACTORY)
		$(cmake-utils_use_enable subversion LIBSVN)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}
