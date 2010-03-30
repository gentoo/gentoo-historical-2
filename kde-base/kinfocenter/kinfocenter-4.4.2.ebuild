# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kinfocenter/kinfocenter-4.4.2.ebuild,v 1.1 2010/03/30 21:07:51 spatz Exp $

EAPI="3"

KMNAME="kdebase-apps"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The KDE Info Center"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook ieee1394"

DEPEND="
	sys-apps/pciutils
	ieee1394? ( sys-libs/libraw1394 )
	opengl? ( virtual/glu virtual/opengl )
"
RDEPEND="${DEPEND}
	sys-apps/usbutils
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with ieee1394 RAW1394)
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-meta_src_configure
}
