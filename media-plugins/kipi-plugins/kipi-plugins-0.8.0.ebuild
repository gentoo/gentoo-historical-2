# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/kipi-plugins/kipi-plugins-0.8.0.ebuild,v 1.3 2009/12/07 23:33:07 maekke Exp $

EAPI=2
OPENGL_REQUIRED=optional
KDE_LINGUAS="ar be ca cs da de el en_GB es et fi fr ga gl hi hne is it ja km
lt lv ms nb nds nl nn oc pa pl pt pt_BR ro ru se sk sv th tr uk zh_CN zh_TW"

inherit kde4-base

DESCRIPTION="KDE Image Plugin Interface"
HOMEPAGE="http://www.kipi-plugins.org/"
SRC_URI="mirror://sourceforge/kipi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="cdr calendar crypt debug +imagemagick ipod mjpeg redeyes scanner"

DEPEND=">=dev-libs/expat-2.0.1
	>=dev-libs/libxml2-2.7
	dev-libs/libxslt
	>=kde-base/libkdcraw-${KDE_MINIMAL}
	>=kde-base/libkexiv2-${KDE_MINIMAL}
	>=kde-base/libkipi-${KDE_MINIMAL}
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2
	>=media-libs/tiff-3.5
	calendar? ( >=kde-base/kdepimlibs-${KDE_MINIMAL} )
	ipod? ( x11-libs/gtk+:2
		>=media-libs/libgpod-0.7 )
	opengl? ( virtual/opengl )
	redeyes? ( media-libs/opencv )
	scanner? ( media-gfx/sane-backends
		>=kde-base/libksane-${KDE_MINIMAL} )
	crypt? ( app-crypt/qca:2 )"
RDEPEND="${DEPEND}
	cdr? ( app-cdr/k3b )
	imagemagick? ( media-gfx/imagemagick )
	mjpeg? ( media-video/mjpegtools )"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with ipod GLIB2)
		$(cmake-utils_use_with ipod GObject)
		$(cmake-utils_use_with ipod Gdk)
		$(cmake-utils_use_with ipod Gpod)
		$(cmake-utils_use_with calendar KdepimLibs)
		$(cmake-utils_use_with redeyes OpenCV)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with crypt QCA2)
		$(cmake-utils_use_with scanner Sane)"

	kde4-base_src_configure
}
