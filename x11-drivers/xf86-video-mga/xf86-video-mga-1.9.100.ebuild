# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-mga/xf86-video-mga-1.9.100.ebuild,v 1.1 2007/11/07 09:11:07 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=4

inherit x-modular

DESCRIPTION="Matrox video driver"
KEYWORDS=""
IUSE="dri"
RDEPEND=">=x11-base/xorg-server-1.3"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto
	dri? ( x11-proto/xf86driproto
			x11-proto/glproto
			>=x11-libs/libdrm-2 )"

CONFIGURE_OPTIONS="$(use_enable dri)"

pkg_setup() {
	if use dri && ! built_with_use x11-base/xorg-server dri; then
		die "Build x11-base/xorg-server with USE=dri."
	fi
}
