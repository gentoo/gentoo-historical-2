# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kinfocenter/kinfocenter-4.1.3.ebuild,v 1.1 2008/11/09 02:17:37 scarabeus Exp $

EAPI="2"

KMNAME=kdebase
KMMODULE=apps/${PN}
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The KDE Info Center"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook ieee1394 opengl"

DEPEND="ieee1394? ( sys-libs/libraw1394 )
	opengl? ( virtual/glu virtual/opengl )"
RDEPEND="${DEPEND}
	sys-apps/pciutils
	sys-apps/usbutils"

KMEXTRACTONLY="apps/cmake/modules/"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with ieee1394 RAW1394)
		$(cmake-utils_use_with opengl OpenGL)"

	kde4-meta_src_configure
}
