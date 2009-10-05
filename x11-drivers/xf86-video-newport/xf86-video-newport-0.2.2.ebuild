# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-newport/xf86-video-newport-0.2.2.ebuild,v 1.2 2009/10/05 13:47:54 fauli Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"
XDPVER=4

inherit x-modular

DESCRIPTION="Newport video driver"
KEYWORDS="-* ~mips x86"
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xproto"
