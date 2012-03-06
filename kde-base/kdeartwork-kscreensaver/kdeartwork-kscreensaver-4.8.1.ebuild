# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-kscreensaver/kdeartwork-kscreensaver-4.8.1.ebuild,v 1.1 2012/03/06 23:35:32 dilfridge Exp $

EAPI=4

KMMODULE="kscreensaver"
KMNAME="kdeartwork"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="Extra screensavers for kde"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +eigen +kexiv2 opengl xscreensaver"

# libkworkspace - only as a stub to provide KDE4Workspace config
RDEPEND="
	$(add_kdebase_dep kscreensaver 'opengl?')
	$(add_kdebase_dep libkworkspace)
	media-libs/libart_lgpl
	opengl? ( virtual/opengl )
	xscreensaver? ( x11-misc/xscreensaver )
"
DEPEND="${RDEPEND}
	eigen? ( dev-cpp/eigen:2 )
	kexiv2? ( $(add_kdebase_dep libkexiv2) )
"

PATCHES=( "${FILESDIR}/${PN}-xscreensaver.patch"
	"${FILESDIR}/${PN}-4.5.95-webcollage.patch" )

src_configure() {
	mycmakeargs=(
		-DKSCREENSAVER_SOUND_SUPPORT=ON
		$(cmake-utils_use_with eigen Eigen2)
		$(cmake-utils_use_with kexiv2 Kexiv2)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with xscreensaver)
	)

	kde4-meta_src_configure
}
