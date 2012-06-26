# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-intel/xf86-video-intel-2.10.0-r1.ebuild,v 1.5 2012/06/26 00:08:06 robbat2 Exp $

EAPI=3

inherit linux-info xorg-2

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~ia64 ~x86 -x86-fbsd"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.6
	|| ( <x11-libs/libdrm-2.4.22 x11-libs/libdrm[video_cards_intel] )
	x11-libs/libpciaccess
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXvMC
	>=x11-libs/libxcb-1.5"
DEPEND="${RDEPEND}
	>=x11-proto/dri2proto-1.99.3
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	dri? ( x11-proto/xf86driproto
	       x11-proto/glproto )"

PATCHES=(
"${FILESDIR}/2.10.0-0001-Extract-pixel-value-for-all-formats-to-avoid-hitting.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	xorg-2_pkg_setup
	CONFIGURE_OPTIONS="$(use_enable dri) --enable-xvmc"
}

pkg_postinst() {
	if linux_config_exists \
		&& ! linux_chkconfig_present CONFIG_DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "              i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}
