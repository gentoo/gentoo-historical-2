# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ati/xf86-video-ati-6.5.7.1.ebuild,v 1.1 2005/12/04 23:03:57 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for ati cards"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="dri"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/xproto
	dri? ( x11-proto/xf86driproto 
			>=x11-libs/libdrm-2)"

CONFIGURE_OPTIONS="$(use_enable dri)"

pkg_setup() {
	if use dri && ! built_with_use x11-base/xorg-server dri; then
		die "Build x11-base/xorg-server with USE=dri."
	fi
}
