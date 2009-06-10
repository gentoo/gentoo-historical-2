# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/digikam/digikam-0.10.0-r1.ebuild,v 1.3 2009/06/10 11:21:14 scarabeus Exp $

EAPI="2"

KDE_MINIMAL="4.2"
KDE_LINGUAS="ar be bg ca cs da de el es et eu fa fi fr ga gl he hi is it ja km
ko lt lv lb nds ne nl nn pa pl pt pt_BR ro ru se sk sl sv th tr uk vi zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="addressbook debug geolocation +gphoto2"

DEPEND="
	dev-db/sqlite:3
	>=kde-base/libkdcraw-${KDE_MINIMAL}
	>=kde-base/libkexiv2-${KDE_MINIMAL}
	>=kde-base/libkipi-${KDE_MINIMAL}
	>=kde-base/solid-${KDE_MINIMAL}
	>=media-libs/jasper-1.701.0
	media-libs/jpeg
	>=media-libs/lcms-1.17
	>=media-libs/libpng-1.2.26-r1
	>=media-libs/tiff-3.8.2-r3
	sys-devel/gettext
	x11-libs/qt-core[qt3support]
	x11-libs/qt-sql[sqlite]
	addressbook? ( >=kde-base/kdepimlibs-${KDE_MINIMAL} )
	geolocation? ( >=kde-base/marble-${KDE_MINIMAL} )
	gphoto2? ( >=media-libs/libgphoto2-2.4.1-r1 )
"
#liblensfun when added should be also optional dep.
RDEPEND="${DEPEND}
	!media-gfx/digikam:0
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	# Fix files collision, use icon from kdebase-data rather that digikam ones
	# and i hate when upstream forces us to do this :(
	rm -rf data/icons/oxygen/{16x16,22x22,32x32,64x64,48x48,128x128,scalable\
}/{actions/{view-object-histogram-linear,transform-crop-and-resize,\
view-object-histogram-logarithmic},apps/{digikam,showfoto}}.{svgz,png}

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_enable gphoto2 GPHOTO2)
		$(cmake-utils_use_with addressbook KdepimLibs)
		$(cmake-utils_use_with geolocation MarbleWidget)"
	# $(cmake-utils_use_with lens LensFun)

	kde4-base_src_configure
}
