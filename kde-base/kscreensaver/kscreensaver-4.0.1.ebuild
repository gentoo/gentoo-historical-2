# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kscreensaver/kscreensaver-4.0.1.ebuild,v 1.2 2008/03/04 03:09:08 jer Exp $

EAPI="1"

KMNAME=kdebase-workspace
inherit kde4-meta

DESCRIPTION="KDE screensaver framework"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="debug opengl pam"

COMMONDEPEND="
	dev-libs/glib
	>=x11-libs/libxklavier-3.2
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXtst
	opengl? ( virtual/opengl )
	pam? ( >=kde-base/kdebase-pam-7
		sys-libs/pam )"
DEPEND="${COMMONDEPEND}
	x11-proto/randrproto"
RDEPEND="${COMMONDEPEND}"

PATCHES="${FILESDIR}/kdebase-${PV}-pam-optional.patch"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with pam PAM)"
	kde4-meta_src_compile
}
