# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ati/xf86-video-ati-6.14.4-r1.ebuild,v 1.7 2012/07/11 19:40:35 ranger Exp $

EAPI=4

XORG_DRI=always
inherit xorg-2

DESCRIPTION="ATI video driver"

KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/libdrm-2.4.33[video_cards_radeon]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.14.4-exa-solid-accel-r300.patch
	"${FILESDIR}"/${PN}-6.14.4-exa-solid-accel-evergreen.patch
	"${FILESDIR}"/${PN}-6.14.4-exa-solid-accel-r100.patch
	"${FILESDIR}"/${PN}-6.14.4-exa-solid-accel-r200.patch
)

pkg_setup() {
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		--enable-dri
		--enable-kms
		--enable-exa
	)
}
