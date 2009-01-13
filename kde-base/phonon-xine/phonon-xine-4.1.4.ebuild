# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/phonon-xine/phonon-xine-4.1.4.ebuild,v 1.1 2009/01/13 23:29:16 alexxy Exp $

EAPI="2"

KMNAME=kdebase-runtime
KMMODULE=phonon
inherit kde4-meta

DESCRIPTION="KDE Phonon Xine backend"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug +xcb"

# There's currently only a xine backend for phonon available,
# a gstreamer backend from TrollTech is in the works.
DEPEND="!kde-base/phonon:${SLOT}
	>=media-sound/phonon-4.2.0
	>=media-libs/xine-lib-1.1.15-r1
	xcb? ( x11-libs/libxcb )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with xcb XCB)
		-DWITH_Xine=ON"

	kde4-meta_src_configure
}
