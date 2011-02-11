# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/digikam/digikam-1.2.0-r4.ebuild,v 1.5 2011/02/11 20:33:40 xarthisius Exp $

EAPI=3

KDE_LINGUAS="ar be bg ca cs da de el es et eu fa fi fr ga gl he hi is it ja km
ko lt lv lb nds ne nl nn pa pl pt pt_BR ro ru se sk sl sv th tr uk vi zh_CN zh_TW"
KMNAME="extragear/graphics"
inherit kde4-base

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	handbook? ( mirror://gentoo/${PN}-doc-1.4.0.tar.bz2 )"

LICENSE="GPL-2
	handbook? ( FDL-1.2 )"
KEYWORDS="amd64 ~ppc x86"
SLOT="4"
IUSE="addressbook debug doc geolocation gphoto2 handbook lensfun semantic-desktop +thumbnails video"

CDEPEND="
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop?]
	>=kde-base/libkdcraw-${KDE_MINIMAL}
	>=kde-base/libkexiv2-${KDE_MINIMAL}
	>=kde-base/libkipi-${KDE_MINIMAL}
	>=kde-base/solid-${KDE_MINIMAL}
	media-libs/jasper
	virtual/jpeg
	media-libs/lcms:0
	media-libs/liblqr
	media-libs/libpng
	media-libs/tiff
	media-libs/libpgf
	>=media-plugins/kipi-plugins-1.2.0-r1
	virtual/lapack
	x11-libs/qt-gui[qt3support]
	x11-libs/qt-sql[sqlite]
	addressbook? ( >=kde-base/kdepimlibs-${KDE_MINIMAL} )
	geolocation? ( >=kde-base/marble-${KDE_MINIMAL} )
	gphoto2? ( media-libs/libgphoto2 )
	lensfun? ( media-libs/lensfun )
"
RDEPEND="${CDEPEND}
	>=kde-base/kreadconfig-${KDE_MINIMAL}
	video? (
		|| (
			>=kde-base/mplayerthumbs-${KDE_MINIMAL}
			>=kde-base/ffmpegthumbs-${KDE_MINIMAL}
		)
	)
"
# gcc[fortran] is required since we cannot otherwise link to the lapack library
#   (the fun of unbundling)
DEPEND="${CDEPEND}
	sys-devel/gcc[fortran]
	sys-devel/gettext
	doc? (
		app-doc/doxygen
		virtual/latex-base
		)
"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}"-{ratingwidget,libpgf-r3,docs-r3,lapack}.patch )

src_prepare() {
	if use handbook; then
		mv "${WORKDIR}/${PN}"-1.4.0/* "${S}/" || die
	else
		mkdir doc || die
		echo > doc/CMakeLists.txt || die
	fi

	kde4-base_src_prepare
}

src_configure() {
	local backend

	use semantic-desktop && backend="Nepomuk" || backend="None"
	# LQR = only allows to choose between bundled/external
	mycmakeargs=(
		-DWITH_LQR=ON
		-DGWENVIEW_SEMANTICINFO_BACKEND=${backend}
		$(cmake-utils_use_with addressbook KdepimLibs)
		$(cmake-utils_use_build doc)
		$(cmake-utils_use_with geolocation MarbleWidget)
		$(cmake-utils_use_enable gphoto2 GPHOTO2)
		$(cmake-utils_use_with gphoto2)
		$(cmake-utils_use_with lensfun LensFun)
		$(cmake-utils_use_with semantic-desktop Soprano)
		-DENABLE_THEMEDESIGNER=OFF
		$(cmake-utils_use_enable thumbnails THUMBS_DB)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	if use doc; then
		# install the api documentation
		dodir /usr/share/doc/${PF}/html || die
		insinto /usr/share/doc/${PF}/html
		doins -r ${CMAKE_BUILD_DIR}/api/html/* || die
	fi

	if use handbook; then
		dodoc readme-handbook.txt || die
	fi
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if use doc; then
		elog The digikam api documentation has been installed at /usr/share/doc/${PF}/html
	fi
}
