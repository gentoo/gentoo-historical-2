# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sis/xf86-video-sis-0.9.1-r1.ebuild,v 1.6 2008/11/26 23:24:00 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="SiS and XGI video driver"
KEYWORDS="amd64 arm ia64 ppc sh x86 ~x86-fbsd"
IUSE="dri"
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xf86miscproto
	x11-proto/xineramaproto
	x11-proto/xproto
	dri? ( x11-proto/xf86driproto
			>=x11-libs/libdrm-2 )"

CONFIGURE_OPTIONS="$(use_enable dri)"

PATCHES="${FILESDIR}/${PN}-assert.patch"
